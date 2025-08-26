<template>
  <div class="w-full">
    <DataTable :value="loading ? skeletonRows : medicalImages" class="mx-4 rounded-lg overflow-hidden text-xs"
      stripedRows showGridlines scrollable scrollHeight="400px">
      <template #empty> {{ $t("medical_images.no_images") }} </template>
      <template #loading> {{ $t("medical_images.loading") }} </template>

      <template #header>
        <div class="flex justify-between items-center !m-b-1">
          <div class="flex">
            <Button type="button" icon="pi pi-refresh !text-xs" label="" v-tooltip.bottom="$t('medical_images.refresh')"
              class="!text-xs ml-2 !w-8 !h-8" @click="refreshData" />
            <Button icon="pi pi-plus" @click="showAddMedicalImageModal" v-tooltip.bottom="$t('medical_images.add')"
              class="p-button p-component p-button-icon-only !text-xs !w-8 !h-8 ml-2" />
          </div>
          <h2 class="text-sm !mb-0 pb-0 flex">
            <i class="fa-solid fa-x-ray ltr:mr-2 rtl:ml-2"></i>
            {{ $t("medical_images.title") }}
          </h2>
        </div>
      </template>

      <Column field="type" :header="$t('medical_images.headers.type')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.type }}
        </template>
      </Column>

      <Column field="image_date" :header="$t('medical_images.headers.date')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.image_date }}
        </template>
      </Column>

      <Column field="organ" :header="$t('medical_images.headers.organ')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.organ }}
        </template>
      </Column>

      <Column field="measurements" :header="$t('medical_images.headers.measurements')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.measurements }}
        </template>
      </Column>

      <Column field="description" :header="$t('medical_images.headers.description')" class="w-2/5">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          {{ slotProps.data.description }}
        </template>
      </Column>

      <Column field="ref_number" :header="$t('medical_images.headers.ref_number')" class="w-1/10">
        <template v-if="loading" #body>
          <Skeleton width="100%" height="1rem" />
        </template>
        <template v-else #body="slotProps">
          <Button type="button" icon="fa-solid fa-x-ray" v-tooltip.top="{
            value: $t('pet_details.view_images'),
            pt: {
              arrow: { style: { borderTopColor: 'var(--p-primary-color)' } },
              text: '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }" raised rounded variant="text" size="small" class="p-component !text-sm ml-2"
            v-if="slotProps.data.type !== `Grooming` && slotProps.data.files.length > 0"
            @click.prevent="showImageGallery(slotProps.data.files, slotProps.data.ref_number)" />
          <span v-else-if="slotProps.data.ref_number">{{ slotProps.data.ref_number }}</span>
        </template>
      </Column>

      <Column header="" class="whitespace-nowrap w-1/10">
        <template #body="slotProps">
          <Button type="button" icon="fa-solid fa-pencil !text-primary" v-tooltip.top="{
            value: $t('medical_images.actions.edit'),
            pt: {
              arrow: { style: { borderTopColor: 'var(--p-primary-color)' } },
              text: '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }" rounded variant="text" size="small" class="!text-xs !text-primary"
            @click="showEditMedicalImageModal(slotProps.data.id)" />
          <Button icon="fa-solid fa-times !text-primary" v-tooltip.top="{
            value: $t('medical_images.actions.delete'),
            pt: {
              arrow: { style: { borderTopColor: 'var(--p-primary-color)' } },
              text: '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
            },
          }" rounded variant="text" size="small" class="!text-x !text-primary"
            @click.prevent="confirmDelete(slotProps.data.id)" v-if="slotProps.data.type !== `Grooming`" />
        </template>
      </Column>
    </DataTable>

    <!-- Image Gallery Dialog -->
    <Dialog v-model:visible="displayGallery" :style="{ width: '90vw', maxWidth: '1000px' }"
      :header="$t('medical_images.gallery.title')" :modal="true" class="gallery-dialog">
      <div class="gallery-container" ref="galleryFsRoot"
        :class="{ 'fs-root': isFullscreen && fullscreenTarget === 'gallery' }">
        <!-- Main image display with zoom/pan -->
        <div class="main-image-container" ref="imageContainer" @wheel.prevent="(e) => handleWheel('gallery', e)"
          @pointerdown="(e) => startPanning('gallery', e)" @pointermove="(e) => onPointerMove('gallery', e)"
          @pointerup="(e) => stopPanning('gallery', e)" @pointercancel="(e) => stopPanning('gallery', e)"
          @pointerleave="(e) => stopPanning('gallery', e)">
          <img :src="currentImageUrl" :alt="'Medical image ' + (activeImageIndex + 1)" ref="zoomImage"
            class="zoom-image" :class="{ 'panning-active': isPanning }" :style="zoomStyle" draggable="false"
            @dragstart.prevent />

          <!-- Controls -->
          <div class="zoom-controls">
            <Button icon="pi pi-plus" @click="zoomIn" class="p-button-rounded p-button-text zoom-btn"
              v-tooltip="$t('medical_images.gallery.zoom_in')" />
            <Button icon="pi pi-minus" @click="zoomOut" class="p-button-rounded p-button-text zoom-btn"
              v-tooltip="$t('medical_images.gallery.zoom_out')" />
            <Button icon="pi pi-refresh" @click="resetZoom" class="p-button-rounded p-button-text zoom-btn"
              v-tooltip="$t('medical_images.gallery.reset_zoom')" />
            <Button
              :icon="isFullscreen && fullscreenTarget === 'gallery' ? 'pi pi-window-minimize' : 'pi pi-window-maximize'"
              @click="toggleFullscreen('gallery')" class="p-button-rounded p-button-text zoom-btn"
              v-tooltip="isFullscreen && fullscreenTarget === 'gallery' ? $t('common.exit_fullscreen') : $t('common.fullscreen')" />
          </div>
        </div>

        <!-- Thumbnails -->
        <div class="thumbnail-container">
          <div v-for="(image, index) in galleryImages" :key="index"
            :class="['thumbnail', { active: activeImageIndex === index }]" @click="setActiveImage(index)">
            <img :src="`https://vet-api.ids-tech.net/storage/${image.file_path}`" :alt="'Thumbnail ' + (index + 1)"
              draggable="false" @dragstart.prevent />
          </div>
        </div>

        <!-- Navigation -->
        <div class="gallery-navigation">
          <Button icon="pi pi-chevron-left" @click="prevImage" class="p-button-rounded nav-btn"
            :disabled="activeImageIndex === 0" />
          <span class="image-counter">{{ activeImageIndex + 1 }} / {{ galleryImages.length }}</span>
          <Button icon="pi pi-chevron-right" @click="nextImage" class="p-button-rounded nav-btn"
            :disabled="activeImageIndex === galleryImages.length - 1" />
        </div>
      </div>

      <template #footer>
        <Button :label="$t('common.close')" icon="pi pi-times" @click="displayGallery = false" class="p-button-text" />
        <Button :label="$t('medical_images.gallery.download')" icon="pi pi-download" @click="downloadCurrentImage" />
      </template>
    </Dialog>

    <!-- Image Preview Dialog -->
    <Dialog v-model:visible="showPreview" :style="{ width: '90vw', maxWidth: '1000px' }"
      :header="$t('add_medical_image.preview_title')" :modal="true" class="preview-dialog">
      <div class="preview-container fs-wrapper" ref="previewFsRoot"
        :class="{ 'fs-root': isFullscreen && fullscreenTarget === 'preview' }"
        @wheel.prevent="(e) => handleWheel('preview', e)" @pointerdown="(e) => startPanning('preview', e)"
        @pointermove="(e) => onPointerMove('preview', e)" @pointerup="(e) => stopPanning('preview', e)"
        @pointercancel="(e) => stopPanning('preview', e)" @pointerleave="(e) => stopPanning('preview', e)">
        <img :src="previewImageUrl" :alt="$t('add_medical_image.preview_alt')" ref="previewImage" class="zoom-image"
          :class="{ 'panning-active': isPanning }" :style="zoomStyle" draggable="false" @dragstart.prevent />

        <div class="zoom-controls">
          <Button icon="pi pi-plus" @click="zoomIn" class="p-button-rounded p-button-text zoom-btn"
            v-tooltip="$t('medical_images.gallery.zoom_in')" />
          <Button icon="pi pi-minus" @click="zoomOut" class="p-button-rounded p-button-text zoom-btn"
            v-tooltip="$t('medical_images.gallery.zoom_out')" />
          <Button icon="pi pi-refresh" @click="resetZoom" class="p-button-rounded p-button-text zoom-btn"
            v-tooltip="$t('medical_images.gallery.reset_zoom')" />
          <Button
            :icon="isFullscreen && fullscreenTarget === 'preview' ? 'pi pi-window-minimize' : 'pi pi-window-maximize'"
            @click="toggleFullscreen('preview')" class="p-button-rounded p-button-text zoom-btn"
            v-tooltip="isFullscreen && fullscreenTarget === 'preview' ? $t('common.exit_fullscreen') : $t('common.fullscreen')" />
        </div>
      </div>

      <template #footer>
        <Button :label="$t('common.close')" icon="pi pi-times" @click="showPreview = false" class="p-button-text" />
        <Button :label="$t('add_medical_image.download')" icon="pi pi-download"
          @click="downloadFile(previewImageUrl)" />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch, computed, nextTick } from "vue";
import { useI18n } from "vue-i18n";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Button from "primevue/button";
import axiosInstance from "@/axios";
import eventBus from "@/eventBus";
import { useConfirm } from "primevue/useconfirm";
import Dialog from "primevue/dialog";

const { t } = useI18n();
const confirm = useConfirm();

const medicalImages = ref([]);
const loading = ref(false);
const displayGallery = ref(false);
const galleryImages = ref([]);
const activeImageIndex = ref(0);
const isNewMedicalImageVisible = ref(false);
const showPreview = ref(false);
const previewImageUrl = ref("");

// Zoom & pan state
const MIN_ZOOM = 1;
const MAX_ZOOM = 5;
const zoomLevel = ref(1);
const panPosition = ref({ x: 0, y: 0 });

// Pointer/pan helpers
const isPanning = ref(false);
const pointerStart = ref({ x: 0, y: 0 });
const panAtStart = ref({ x: 0, y: 0 });

const imageContainer = ref(null);
const previewContainer = ref(null);
const zoomImage = ref(null);
const previewImage = ref(null);

// Natural size cache
const naturalSize = ref({ w: 0, h: 0 });

// Fullscreen
const isFullscreen = ref(false);
const fullscreenTarget = ref(null); // 'gallery' | 'preview' | null
const galleryFsRoot = ref(null);
const previewFsRoot = ref(null);

const skeletonRows = Array.from({ length: 4 }).map(() => ({
  type: "",
  organ: "",
  measurements: "",
  description: "",
  ref_number: "",
}));

const props = defineProps({
  medical_record_id: { type: Number, required: true },
});

const emit = defineEmits();
const activeRefNumber = ref("")
const showImageGallery = (files, ref_number) => {
  galleryImages.value = files;
  activeImageIndex.value = 0;
  activeRefNumber.value = `${ref_number}`;
  displayGallery.value = true;
  nextTick(loadNaturalSizeFor('gallery'));
};

const setActiveImage = (index) => {
  activeImageIndex.value = index;
  resetZoom();
  nextTick(loadNaturalSizeFor('gallery'));
};

const getImageUrl = (filePath) => `${axiosInstance.defaults.baseURL}/${filePath}`;

const currentImageUrl = computed(() => {
  if (!galleryImages.value.length) return "";
  return `https://vet-api.ids-tech.net/storage/${galleryImages.value[activeImageIndex.value].file_path}`;
});

// Translate then scale
const zoomStyle = computed(() => ({
  transform: `translate(${panPosition.value.x}px, ${panPosition.value.y}px) scale(${zoomLevel.value})`,
  cursor: zoomLevel.value > 1 ? (isPanning.value ? "grabbing" : "grab") : "default",
}));

const fetchMedicalImages = async () => {
  loading.value = true;
  try {
    const { data } = await axiosInstance.get(`/medical-images/bymrid/${props.medical_record_id}`);
    medicalImages.value = data.data;
  } catch (e) {
    console.error("Error fetching medical images:", e);
  } finally {
    loading.value = false;
  }
};

const previewFile = (filePath) => {
  previewImageUrl.value = `https://vet-api.ids-tech.net/storage/${filePath}`;
  showPreview.value = true;
  nextTick(loadNaturalSizeFor('preview'));
};

const showAddMedicalImageModal = () => emit("showAddMedicalImageModal");
const showEditMedicalImageModal = (id) => emit("showEditMedicalImageModal", id);

const refreshData = () => {
  loading.value = true;
  fetchMedicalImages();
};

const handleSubmit = (newImageData) => {
  isNewMedicalImageVisible.value = false;
  medicalImages.value.push(newImageData);
  eventBus.emit("show-toast", {
    severity: "success",
    summary: t("medical_images.toast.title"),
    detail: t("medical_images.toast.success", { type: newImageData.type }),
    life: 5000,
  });
};

const confirmDelete = (medicalImageId) => {
  confirm.require({
    message: t("medical_images.delete_confirm.message"),
    header: t("medical_images.delete_confirm.header"),
    icon: "pi pi-exclamation-triangle",
    acceptClass: "p-button-danger",
    accept: () => deleteImage(medicalImageId),
  });
};

const deleteImage = async (medicalImageId) => {
  try {
    await axiosInstance.delete(`/medical-images/${medicalImageId}`);
    fetchMedicalImages();
    eventBus.emit("ImagetDeletedSuccessfully");
  } catch (e) {
    console.error("Failed to delete Image:", e);
  }
};

// ---------- Zoom ----------
const zoomIn = () => setZoomAtCenter(zoomLevel.value * 1.25);
const zoomOut = () => setZoomAtCenter(zoomLevel.value / 1.25);
const resetZoom = () => {
  zoomLevel.value = 1;
  panPosition.value = { x: 0, y: 0 };
};

function clampZoom(z) {
  return Math.min(Math.max(z, MIN_ZOOM), MAX_ZOOM);
}

function setZoomAtPoint(newZoom, containerEl, clientX = null, clientY = null) {
  const oldZoom = zoomLevel.value;
  newZoom = clampZoom(newZoom);
  // if (newZoom === oldZoom) return;

  const rect = containerEl.getBoundingClientRect();
  const cx = (clientX ?? (rect.left + rect.width / 2)) - (rect.left + rect.width / 2);
  const cy = (clientY ?? (rect.top + rect.height / 2)) - (rect.top + rect.height / 2);

  const k = newZoom / oldZoom;
  panPosition.value = {
    x: panPosition.value.x - cx * (k - 1),
    y: panPosition.value.y - cy * (k - 1),
  };

  zoomLevel.value = newZoom;
  clampPan();
}

function setZoomAtCenter(newZoom) {
  const el = displayGallery.value ? imageContainer.value : previewContainer.value;
  if (!el) return;
  setZoomAtPoint(newZoom, el);
}

const handleWheel = (which, event) => {
  const el = which === 'gallery' ? imageContainer.value : previewContainer.value;
  if (!el) return;
  const factor = Math.pow(1.0015, -event.deltaY);
  const proposed = clampZoom(zoomLevel.value * factor);
  setZoomAtPoint(proposed, el, event.clientX, event.clientY);
  clampPan();
};

// ---------- Pan (Pointer Events) ----------
const startPanning = (which, e) => {
  if (zoomLevel.value <= 1) return;
  isPanning.value = true;
  const el = which === 'gallery' ? imageContainer.value : previewContainer.value;
  el?.setPointerCapture?.(e.pointerId);
  pointerStart.value = { x: e.clientX, y: e.clientY };
  panAtStart.value = { ...panPosition.value };
};

const onPointerMove = (which, e) => {
  if (!isPanning.value || zoomLevel.value <= 1) return;
  const dx = e.clientX - pointerStart.value.x;
  const dy = e.clientY - pointerStart.value.y;
  panPosition.value = { x: panAtStart.value.x + dx, y: panAtStart.value.y + dy };
  clampPan();
};

const stopPanning = (which, e) => {
  if (!isPanning.value) return;
  isPanning.value = false;
  const el = which === 'gallery' ? imageContainer.value : previewContainer.value;
  el?.releasePointerCapture?.(e.pointerId);
};

// ---------- Bounds ----------
function loadNaturalSizeFor(which) {
  return () => {
    const imgEl = which === 'gallery' ? zoomImage.value : previewImage.value;
    if (!imgEl) return;
    const apply = () => {
      naturalSize.value = { w: imgEl.naturalWidth || 0, h: imgEl.naturalHeight || 0 };
      clampPan();
    };
    if (imgEl.complete && imgEl.naturalWidth) apply();
    else imgEl.addEventListener("load", apply, { once: true });
  };
}

function currentBounds() {
  const containerEl = displayGallery.value ? imageContainer.value : previewContainer.value;
  const imgW = naturalSize.value.w;
  const imgH = naturalSize.value.h;
  if (!containerEl || !imgW || !imgH) return { maxX: 0, maxY: 0 };

  const cw = containerEl.clientWidth;
  const ch = containerEl.clientHeight;

  const scaleToFit = Math.min(cw / imgW, ch / imgH);
  const baseW = imgW * scaleToFit;
  const baseH = imgH * scaleToFit;

  const zoomedW = baseW * zoomLevel.value;
  const zoomedH = baseH * zoomLevel.value;

  const overflowX = Math.max(0, (zoomedW - cw) / 2);
  const overflowY = Math.max(0, (zoomedH - ch) / 2);

  return { maxX: overflowX, maxY: overflowY };
}

function clampPan() {
  const { maxX, maxY } = currentBounds();
  panPosition.value = {
    x: Math.min(Math.max(panPosition.value.x, -maxX), maxX),
    y: Math.min(Math.max(panPosition.value.y, -maxY), maxY),
  };
}

// ---------- Gallery navigation ----------
const nextImage = () => {
  if (activeImageIndex.value < galleryImages.value.length - 1) {
    activeImageIndex.value++;
    resetZoom();
    nextTick(loadNaturalSizeFor('gallery'));
  }
};

const prevImage = () => {
  if (activeImageIndex.value > 0) {
    activeImageIndex.value--;
    resetZoom();
    nextTick(loadNaturalSizeFor('gallery'));
  }
};

// ---------- Downloads ----------
// const downloadFile = (url) => {
//   const a = document.createElement("a");
//   a.href = url;
//   a.download = "";
//   document.body.appendChild(a);
//   a.click();
//   a.remove();
// };

// const downloadFile = async (url, filename = activeRefNumber.value) => {
// const downloadFile = (url, filename = activeRefNumber.value) => {
const downloadFile = async (url, filename = activeRefNumber.value) => {

  try {
    // Fetch the file
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    // Get the blob data and determine file type
    const blob = await response.blob();

    // Create a new blob with explicit type to force download
    const newBlob = new Blob([blob], {
      type: 'application/octet-stream' // This type often forces download
    });

    // Create object URL from blob
    const blobUrl = URL.createObjectURL(newBlob);

    // Create download link
    const a = document.createElement("a");
    a.href = blobUrl;
    a.download = filename || 'download';
    a.style.display = 'none';

    // Append to body, click, and clean up
    document.body.appendChild(a);
    a.click();

    // Clean up
    setTimeout(() => {
      document.body.removeChild(a);
      URL.revokeObjectURL(blobUrl);
    }, 100);

  } catch (error) {
    console.error('Download failed:', error);
    window.open(url, '_blank');
  }
};

const downloadCurrentImage = () => {
  if (galleryImages.value.length > 0) {
    const imageUrl = `https://vet-api.ids-tech.net/storage/${galleryImages.value[activeImageIndex.value].file_path}`;
    downloadFile(imageUrl);
  }
};

// ---------- Fullscreen ----------
function getFsElement(which) {
  return which === 'gallery' ? galleryFsRoot.value : previewFsRoot.value;
}

async function enterFullscreen(which) {
  const el = getFsElement(which);
  if (!el) return;
  fullscreenTarget.value = which;
  try {
    if (el.requestFullscreen) await el.requestFullscreen();
    else if (el.webkitRequestFullscreen) el.webkitRequestFullscreen();
  } catch (e) {
    console.warn("Fullscreen request failed:", e);
  }
}

async function exitFullscreen() {
  try {
    if (document.fullscreenElement) await document.exitFullscreen();
    else if (document.webkitFullscreenElement) document.webkitExitFullscreen?.();
  } catch (e) {
    console.warn("Exit fullscreen failed:", e);
  }
}

function toggleFullscreen(which) {
  if (isFullscreen.value && fullscreenTarget.value === which) exitFullscreen();
  else enterFullscreen(which);
}

function onFullscreenChange() {
  const fsEl = document.fullscreenElement || document.webkitFullscreenElement;
  isFullscreen.value = !!fsEl;
  if (!isFullscreen.value) {
    fullscreenTarget.value = null;
  }
  nextTick(() => clampPan());
}

function onKeyDown(e) {
  if (e.key?.toLowerCase() !== 'f') return;
  if (displayGallery.value) toggleFullscreen('gallery');
  else if (showPreview.value) toggleFullscreen('preview');
}

// ---------- Lifecycle ----------
onMounted(() => {
  eventBus.on("newImageAdded", fetchMedicalImages);
  eventBus.on("MedicalImageUpdatedSuccessfully", fetchMedicalImages);
  fetchMedicalImages();

  document.addEventListener("fullscreenchange", onFullscreenChange);
  document.addEventListener("webkitfullscreenchange", onFullscreenChange);
  window.addEventListener("keydown", onKeyDown);
});

onBeforeUnmount(() => {
  document.removeEventListener("fullscreenchange", onFullscreenChange);
  document.removeEventListener("webkitfullscreenchange", onFullscreenChange);
  window.removeEventListener("keydown", onKeyDown);
});

// Exit FS when dialogs close
watch(displayGallery, async (open) => {
  if (!open && isFullscreen.value && fullscreenTarget.value === 'gallery') await exitFullscreen();
  if (!open) resetZoom();
  else nextTick(loadNaturalSizeFor('gallery'));
});

watch(showPreview, async (open) => {
  if (!open && isFullscreen.value && fullscreenTarget.value === 'preview') await exitFullscreen();
  if (!open) resetZoom();
  else nextTick(loadNaturalSizeFor('preview'));
});
</script>

<style scoped>
.gallery-dialog,
.preview-dialog {
  max-height: 90vh;
}

.gallery-container,
.preview-container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Fullscreen root */
.fs-root {
  width: 100vw;
  height: 100vh;
}

.main-image-container,
.preview-container {
  position: relative;
  overflow: hidden;
  height: 60vh;
  background-color: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;

  touch-action: none;
  user-select: none;
}

/* Taller stage when fullscreen */
.fs-root .main-image-container,
.fs-root.preview-container {
  height: calc(100vh - 160px);
}

.zoom-image {
  transform-origin: center center;
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  -webkit-user-drag: none;
  user-select: none;
  transition: transform 0.12s ease;
}

.zoom-image.panning-active {
  transition: none;
}

.zoom-controls {
  position: absolute;
  bottom: 1rem;
  right: 1rem;
  display: flex;
  gap: 0.5rem;
  background: rgba(255, 255, 255, 0.8);
  padding: 0.5rem;
  border-radius: 50px;
}

.zoom-btn {
  width: 2.5rem;
  height: 2.5rem;
}

.thumbnail-container {
  display: flex;
  gap: 0.5rem;
  overflow-x: auto;
  padding: 0.5rem 0;
}

.thumbnail {
  width: 80px;
  height: 80px;
  flex-shrink: 0;
  border: 2px solid transparent;
  border-radius: 4px;
  overflow: hidden;
  cursor: pointer;
  opacity: 0.7;
  transition: all 0.2s ease;
}

.thumbnail:hover {
  opacity: 0.9;
  transform: scale(1.05);
}

.thumbnail.active {
  border-color: var(--primary-color);
  opacity: 1;
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  -webkit-user-drag: none;
}

.gallery-navigation {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
}

.nav-btn {
  width: 3rem;
  height: 3rem;
}

.image-counter {
  font-weight: 500;
  min-width: 60px;
  text-align: center;
}

@media (max-width: 768px) {

  .gallery-dialog,
  .preview-dialog {
    width: 95vw !important;
  }

  .main-image-container,
  .preview-container {
    height: 50vh;
  }

  .zoom-controls {
    bottom: 0.5rem;
    right: 0.5rem;
  }

  .thumbnail {
    width: 60px;
    height: 60px;
  }
}

:deep(.p-dialog-content) {
  overflow-y: visible !important;
}
</style>
