<template>
  <div class="flex gap-2 h-[calc(100vh-60px)] overflow-y-auto my-4 w-full">
    <div
      class="w-1/4 h-fit bg-[var(--p-surface-200)] dark:bg-[var(--p-surface-600)] rounded-lg p-2"
    >
      <Card class="w-full">
        <template #header>
          <!-- <img alt="user header" src="/images/usercard.png" /> -->
          <Button
            @click="router.go(-1)"
            class="p-button p-component p-button-icon-only !w-6 h-6 !text-xs m-2"
            icon="pi pi-arrow-left !text-xs"
            v-tooltip.top="{
              value: 'Go back',
              pt: {
                arrow: {
                  style: {
                    borderTopColor: 'var(--p-primary-color)',
                  },
                },
                text:
                  '!bg-[var(--p-primary-color)] !font-thin 2xl:!text-lg lg:!text-xs shadow-md',
              },
            }"
          />

          <div class="flex justify-center mt-8"><i class="fas fa-paw text-3xl"></i></div>
        </template>
        <template #title>
          <Skeleton v-if="loading" width="12rem" height="2rem" />
          <div v-else>{{ pet.name }}</div></template
        >
        <template #subtitle>
          <div class="flex gap-4">
            <Skeleton v-if="loading" width="12rem" height="2rem" />
            <Chip
              v-else
              v-tooltip.top="{
                value: 'Microchip/Serial Number',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              class="!text-sm border"
            >
              <i class="fas fa-microchip"></i> {{ pet.microchip_num }}
            </Chip>
          </div>
        </template>
        <template #content>
          <div v-if="loading">
            <Skeleton class="mt-2" width="12rem" height="2rem" />
            <Skeleton width="12rem" height="2rem" />
            <Skeleton class="mt-2" width="9rem" height="2rem" />
            <Skeleton class="mt-2" width="10rem" height="2rem" />
            <Skeleton class="mt-2" width="5rem" height="2rem" />
            <Skeleton class="mt-2" width="5rem" height="2rem" />
          </div>
          <div v-else class="flex flex-wrap gap-1">
            <Chip class="2xl:text-xs text-sm mt-2 border">
              <router-link
                :to="`/` + pet.owner.id + `/pets`"
                v-tooltip.top="{
                  value: 'View Patients',
                  pt: {
                    arrow: {
                      style: {
                        borderTopColor: 'var(--p-primary-color)',
                      },
                    },
                    text:
                      '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                  },
                }"
                ><i class="fas fa-users"></i> {{ pet.owner.name }}
                <i class="pi pi-external-link !text-[0.6rem] text-gray-500"></i>
              </router-link>
            </Chip>

            <Chip class="2xl:text-xs text-sm mt-2 border">
              <i :class="getIconClass(pet.species)"></i>
              {{ getSpeciesValue(pet.species) }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: 'Breed',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
            >
              {{ pet.breed }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 border"
              v-if="pet.color !== null"
              v-tooltip.top="{
                value: 'Color',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
            >
              <i class="fa-solid fa-palette"></i> {{ pet.color }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 border"
              v-if="pet.behaviour !== null"
              v-tooltip.top="{
                value: 'Behavior: ' + pet.behaviour,
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
            >
              <i class="fa-solid fa-face-angry"></i>
              {{ pet.behaviour }}
            </Chip>
            <Chip class="2xl:text-xs text-sm mt-2 border">
              <i
                class="fa-solid fa-venus !text-pink-600"
                v-if="pet.gender === `Female`"
              ></i>
              <i class="fa-solid fa-mars !text-blue-600" v-else></i>
              {{ pet.gender }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 p-button-success p-button-outlined"
              v-if="pet.neutered === 'Y'"
              v-tooltip.top="{
                value: 'Neutered/Spayed', //editPetDetails

                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
            >
              {{ pet.gender === "Male" ? `Neutered` : `Spayed` }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 p-button-danger p-button-outlined"
              v-else
              v-tooltip.top="{
                value: 'Neutered/Spayed', //editPetDetails

                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
              >Not {{ pet.gender === "Male" ? `Neutered` : `Spayed` }}</Chip
            >
            <Chip
              class="2xl:text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: 'Age', //editPetDetails

                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
            >
              <i class="fa-solid fa-cake-candles"></i>
              {{
                pet.deceased === "N" ? computeAge(pet.date_of_birth) : pet.date_of_birth
              }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: 'BIrth Date', //editPetDetails

                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
            >
              <i class="fa-solid fa-cake-candles"></i>
              {{ pet.deceased === "N" ? pet.date_of_birth : pet.date_of_birth }}
            </Chip>
            <Chip
              class="2xl:text-xs text-sm mt-2"
              :class="
                `` + pet.deceased === 'Y'
                  ? `!bg-black !text-white`
                  : `!bg-green-500 !text-white`
              "
            >
              <i v-if="pet.deceased === 'Y'" class="fa-solid fa-heart-crack"></i>
              <i v-else class="fa-solid fa-heart"></i>
              {{ pet.deceased === "Y" ? ` Deceased` : `Alive` }}
              {{
                pet.deceased === "Y" && pet.date_of_morta !== null
                  ? ": " + pet.date_of_morta
                  : ": YES"
              }}
            </Chip>
            <!-- <div
              v-for="(entry, index) in parseResults(pet.allergies)"
              :key="index"
              class="flex gap-2 w-full"
            > -->
            <Chip
              v-if="pet.allergies !== null"
              class="2xl:text-xs text-sm mt-2 p-button-danger p-button-outlined"
              v-tooltip.top="{
                value: 'Allergies: ' + pet.allergies,
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              ><i class="fas fa-disease"></i> {{ pet.allergies }}
            </Chip>
            <!-- </div> -->
            <Chip
              class="2xl:text-xs text-sm mt-2 cursor-pointer"
              v-tooltip.top="{
                value: 'Distinctive Marks', //editPetDetails

                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
            >
              {{ pet.distinctive_marks }}
            </Chip>
            <Button
              type="button"
              icon="fa-solid fa-pencil"
              label="Edit"
              v-tooltip.bottom="`Edit Data`"
              class="2xl:text-xs text-sm mt-2 cursor-pointer !bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md"
              @click="editPetDetails"
            />
          </div>
        </template>
        <template #footer>
          <div class="flex gap-4 mt-1">
            <!-- <Button label="Cancel" severity="secondary" outlined class="w-full" />
            <Button label="Save" class="w-full" /> -->
          </div>
        </template>
      </Card>
    </div>
    <div
      class="w-3/4 min-h-full bg-[var(--p-surface-300)] dark:bg-[var(--p-surface-500)] rounded-lg"
    >
      <DataTable
        :value="visits"
        class="mx-4 my-4 rounded-lg overflow-hidden text-xs"
        stripedRows
        v-if="!loading"
      >
        <template #header>
          <div class="flex flex-wrap items-center justify-between gap-2">
            <span class="text-xl font-bold">Visits History</span>
            <div class="flex gap-2">
              <Button
                v-tooltip.bottom="`Refresh Data`"
                icon="pi pi-plus"
                @click="addAppointment"
                class="p-button p-button-icon-only !text-sm !font-thin h-8"
              />
              <Button
                type="button"
                icon="pi pi-refresh !text-sm"
                label=""
                v-tooltip.bottom="`Refresh Data`"
                class="p-button p-button-icon-only !text-sm !font-thin h-8"
                @click="refreshData"
              />
            </div>
          </div>
        </template>
        <Column field="start" header="Date" :class="`!rtl w-1/8 `"></Column>
        <Column field="title" header="Title" class="font-normal !rtl"></Column>

        <Column
          field="description"
          header="Description"
          class="font-normal rtl:!text-right"
        >
          <template #body="slotProps">
            <div
              class="gap-2 px-1"
              v-html="slotProps.data.description.replace(/\n/g, '<br />')"
            ></div>
          </template>
        </Column>
        <Column field="type" header="Type">
          <template #body="slotProps">
            <Tag
              class="shadow-md border-gray-500 rtl:border-r-2 rtl:border-r-[var(--border-color)] border-l-2 border-l-[var(--border-color)]"
              :style="{
                '--border-color': getEventTheme(slotProps.data.type).lightColors.main,
                '--background-color': getEventTheme(slotProps.data.type).lightColors
                  .container,
                '--text-color': getEventTheme(slotProps.data.type).lightColors
                  .onContainer,
                background: `var(--background-color)`,
                color: `var(--text-color)`,
              }"
            >
              <div class="gap-2 px-1">
                <span class="!text-xs font-normal">{{ slotProps.data.type }}</span>
              </div>
            </Tag>
          </template>
        </Column>
        <Column header="Data" class="w-fit whitespace-nowrap">
          <template #body="slotProps">
            <Button
              type="button"
              icon="fa-solid fa-syringe"
              v-tooltip.top="{
                value: 'View Treatments',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              @click.prevent="listTreatments(slotProps.data.id)"
              v-if="slotProps.data.type !== `Grooming`"
            />
            <Button
              v-if="slotProps.data.type !== `Grooming`"
              type="button"
              icon="fa-solid fa-vials"
              v-tooltip.top="{
                value: 'View Tests',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              @click.prevent="listTestResults(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-x-ray"
              v-tooltip.top="{
                value: 'X-rays & Ultrasound',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              v-if="slotProps.data.type !== `Grooming`"
              @click.prevent="listImages(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-file-medical"
              v-tooltip.top="{
                value: 'Case History',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              v-if="slotProps.data.type !== `Grooming`"
              @click="showCaseHistoryModal(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-stethoscope"
              v-tooltip.top="{
                value: 'Medical Examination',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              v-if="slotProps.data.type !== `Grooming`"
              @click="showPhysicalExaminationModal(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-regular fa-chart-bar"
              v-tooltip.top="{
                value: 'Full Report',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              @click="showFullReportModal(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-dollar-sign"
              v-tooltip.top="{
                value: 'Invoice',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              @click="showAddInvoice(slotProps.data.id)"
            />
            <Button
              type="button"
              icon="fa-solid fa-pen-to-square"
              v-tooltip.top="{
                value: 'Edit Details',
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text:
                    '!bg-[var(--p-primary-color)] !text-primary-contrast !font-thin !text-xs',
                },
              }"
              raised
              rounded
              variant="text"
              size="small"
              class="p-component !text-sm ml-2"
              @click="editAppointment(slotProps.data.id)"
            />
          </template>
        </Column>
        <template #footer>
          In total there are {{ visits ? visits.length : 0 }} records.
        </template>
      </DataTable>
    </div>
  </div>
  <Dialog
    header="Treatments"
    v-model:visible="isTreatmentsListVisible"
    @hide="isTreatmentsListVisible = false"
    modal
    v-show="isTreatmentsListVisible"
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Treatments</span>
      </div>
    </template>
    <PetTreatments
      :medical_record_id="medical_record_id"
      @showAddTreatmentModal="showAddTreatmentModal"
      @showEditTreatmentModal="showEditTreatmentModals"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Edit Pet Details"
    v-model:visible="isEditPetDetailsVisible"
    @hide="isEditPetDetailsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Edit Pet Details</span>
      </div>
    </template>
    <EditPetDetails
      :medical_record_id="medical_record_id"
      @showEditPetDetailsModal="showEditPetDetailsModal"
      @details_updated="handleDetailsUpdated"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Edit Treatment Details"
    v-model:visible="isEditTreatmentVisible"
    @hide="isEditTreatmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Edit Treatment Details</span>
      </div>
    </template>
    <EditTreatment
      @TreatmentUpdated="handleUpdatedTreatment"
      :treatmentId="selectedTreatmentId"
      :medical_record_id="medical_record_id"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Test Results"
    v-model:visible="isTestResultsVisible"
    @hide="isTestResultsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Test Results</span>
      </div>
    </template>
    <TestResults
      :medical_record_id="medical_record_id"
      @showAddTestResultModal="showAddTestResultModal"
      @showEditTestResultModal="showEditTestResultModal"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Medical Image"
    v-model:visible="isEditMedicalImageVisible"
    @hide="isEditMedicalImageVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Test Results</span>
      </div>
    </template>
    <EditMedicalImage
      @MedicalImageUpdated="handleMedicalImageUpdated"
      :medicalImageId="selectedMedicalImageId"
      :medical_record_id="medical_record_id"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="XRays and Images"
    v-model:visible="isImagesListVisible"
    @hide="isImagesListVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">XRays and Images</span>
      </div>
    </template>
    <MedicalImages
      :medical_record_id="medical_record_id"
      @showAddMedicalImageModal="showAddMedicalImageModal"
      @showEditMedicalImageModal="showEditMedicalImageModal"
    />
    <template #footer> </template>
  </Dialog>

  <!-- Add Medical Image Modal -->
  <Dialog
    header="New Medical Image"
    v-model:visible="isNewMedicalImageVisible"
    @hide="isNewMedicalImageVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">New Medical Image</span>
      </div>
    </template>
    <AddNewMedicalImage
      :medical_record_id="medical_record_id"
      @NewImageAdded="handleSubmitNewImage"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="New Treatment"
    v-model:visible="isNewTreatmentVisible"
    @hide="isNewTreatmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">New Treatment</span>
      </div>
    </template>
    <AddNewTreatment
      :medical_record_id="medical_record_id"
      @TreatmentAdded="handleNewTreatment"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="New Test Result"
    v-model:visible="isNewTestResultVisible"
    @hide="isNewTestResultVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">New Test Result</span>
      </div>
    </template>
    <AddNewTestResult
      :medical_record_id="medical_record_id"
      @TestResultAdded="handleNewTestResult"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="New Record"
    v-model:visible="isNewApointmentVisible"
    @hide="isNewApointmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">New Medical Record</span>
      </div>
    </template>
    <addNewAppointment
      :petMicrochip="petmicrochip"
      :petOwnerID="pet.owner.id"
      @submitted="handleSubmit"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="New Record"
    v-model:visible="isEditApointmentVisible"
    @hide="isEditApointmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Edit Medical Record</span>
      </div>
    </template>
    <EditAppointment
      :appointmentId="appointment_id"
      @updated="handleAppointmentUpdated"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Edit Test Result"
    v-model:visible="isEditTestResultsVisible"
    @hide="isEditTestResultsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Edit Test Result</span>
      </div>
    </template>
    <EditTestResult
      :testResultId="selectedTestResultId"
      @TestResultUpdated="handleTestResultUpdated"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <!--@updated="handleTestResultUpdated" -->
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Add Case Histyory"
    v-model:visible="isAddCaseHistorysVisible"
    @hide="isAddCaseHistorysVisible = false"
    modal
    :closable="true"
    class="w-10/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Add Case Histyory</span>
      </div>
    </template>
    <AddCaseHistory
      :medical_record_id="medical_record_id"
      @TestResultUpdated="handleTestResultUpdated"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <!--@updated="handleTestResultUpdated" -->
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Case Histyory"
    v-model:visible="isCaseHistorysVisible"
    @hide="isCaseHistorysVisible = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Case Histyory</span>
      </div>
    </template>
    <CaseHistory
      :medical_record_id="medical_record_id"
      @showAddCaseHistoryModal="showAddCaseHistoryModal"
      @CaseHistoryUpdated="handleCaseHistory"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <!--@updated="handleTestResultUpdated" -->
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Add Physical Examination"
    v-model:visible="isAddPhysicalExamination"
    @hide="isAddPhysicalExamination = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Add Physical Examination</span>
      </div>
    </template>
    <AddPhysicalExamination
      :medical_record_id="medical_record_id"
      @showAddCaseHistoryModal="showAddCaseHistoryModal"
      @CaseHistoryUpdated="handleCaseHistory"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <!--@updated="handleTestResultUpdated" -->
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Physical Examination"
    v-model:visible="isPhysicalExamination"
    @hide="isPhysicalExamination = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Physical Examination</span>
      </div>
    </template>
    <PhysicalExamination
      :medical_record_id="medical_record_id"
      :pet_name="pet.name"
      @showAddPhysicalExaminationModal="showAddPhysicalExaminationModal"
      @PhysicalExaminationUpdated="handlePhysicalExamination"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    header="Full Report"
    v-model:visible="isFullReportVisible"
    @hide="isFullReportVisible = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">Full Report</span>
      </div>
    </template>
    <FullReport
      :medical_record_id="medical_record_id"
      :pet_name="pet.name"
      @showAddPhysicalExaminationModal="showAddPhysicalExaminationModal"
      @PhysicalExaminationUpdated="handlePhysicalExamination"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <!-- View Invoice Dialog -->
  <Dialog
    header="Invoice Details"
    v-model:visible="viewDialogVisible"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceView
      :invoice="selectedInvoice"
      @addInvoice="handleAddInvoiceRequest"
      @addPayment="handleAddPaymentRequest"
    />
    <!-- :paymentMethods="paymentMethods" -->
  </Dialog>

  <Dialog
    :header="'Create New Invoice'"
    v-model:visible="isModalVisible"
    @hide="isModalVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">Create New Invoice</span>
      </div>
    </template>
    <InvoiceAdd
      :pet="pet"
      :medical_record_id="medical_record_id"
      @submitted="handleInvoiceSubmit"
    />
  </Dialog>
  <Dialog
    header="Add Payment"
    v-model:visible="paymentDialogVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-[11/12] md:w-[500px] h-fit bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">Add Payment</span>
      </div>
    </template>
    <AddPayment
      v-if="selectedInvoice"
      :invoice="selectedInvoice"
      :paymentMethods="paymentMethods"
      @submit="handlePaymentSubmit"
      @cancel="paymentDialogVisible = false"
    />
  </Dialog>
  <!-- <ConfirmDialog class="md:w-[35vw] sm:w-full !text-sm">
    <template #message="slotProps">
      <div class="flex flex-col items-center w-full mx-auto gap-4 text-md text-center">
        <i :class="slotProps.message.icon" class="!text-6xl text-yellow-500"></i>
        <p>{{ slotProps.message.message }}</p>
      </div>
    </template>
  </ConfirmDialog> -->
</template>
<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import Card from "primevue/card";
import Chip from "primevue/chip";
import router from "@/router";
import { useRoute } from "vue-router";
import Tag from "primevue/tag";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios"; // Assuming axiosInstance is set up correctly
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton"; // optional
import Dialog from "primevue/dialog";
import PetTreatments from "@/views/TreatmentsList.vue";
import TestResults from "@/views/TestResults.vue";
import AddNewTreatment from "@/views/AddNewTreatment.vue";
import AddNewTestResult from "@/views/AddNewTestResult.vue";
import addNewAppointment from "@/views/addNewAppointment.vue";
import MedicalImages from "@/views/MedicalImages.vue";
import AddNewMedicalImage from "@/views/AddNewMedicalImage.vue";
import EditPetDetails from "@/views/EditPetDetails.vue";
import EditTreatment from "@/views/EditTreatment.vue";
import EditAppointment from "@/views/EditAppointment.vue";
import EditTestResult from "@/views/EditTestResults.vue";
import EditMedicalImage from "@/views/EditMedicalImage.vue";
import AddCaseHistory from "@/views/AddCaseHistory.vue";
import CaseHistory from "@/views/CaseHistory.vue";
import AddPhysicalExamination from "@/views/addNewMedicalExamination.vue";
import PhysicalExamination from "@/views/MedicalExamination.vue";
import FullReport from "@/views/FullReport.vue";
import InvoiceView from "@/views/InvoiceView.vue";
import InvoiceAdd from "@/views/AddInvoice.vue";
import AddPayment from "@/views/AddInvoicePayment.vue";
const emit = defineEmits([]); // Define the event to be emitted

const isTreatmentsListVisible = ref(false);
const isTestResultsVisible = ref(false);
const isNewTreatmentVisible = ref(false);
const isNewMedicalImageVisible = ref(false);
const isNewTestResultVisible = ref(false);
const isNewApointmentVisible = ref(false);
const isEditApointmentVisible = ref(false);
const isImagesListVisible = ref(false);
const isEditPetDetailsVisible = ref(false);
const isEditTreatmentVisible = ref(false);
const isEditTestResultsVisible = ref(false);
const isEditMedicalImageVisible = ref(false);
const isAddCaseHistorysVisible = ref(false);
const isCaseHistorysVisible = ref(false);
const isAddPhysicalExamination = ref(false);
const isPhysicalExamination = ref(false);
const isFullReportVisible = ref(false);
const viewDialogVisible = ref(false);
const isModalVisible = ref(false);
const paymentDialogVisible = ref(false);
const selectedTreatmentId = ref(null);
const selectedTestResultId = ref(null);
const selectedMedicalImageId = ref(null);
const route = useRoute();
const petmicrochip = ref(route.params.petmicrochip);
const selectedInvoice = ref(null);
const pet = ref({
  microchip_num: "",
  name: "",
  species: "",
  breed: "",
  gender: "",
  behaviour: "",
  distinctive_marks: "",
  color: "",
  allergies: "",
  neutered: "",
  date_of_birth: "",
  deceased: "",
  owner: {
    id: "",
    name: "",
  },
});
const treatment_id = ref("");
const showAddTreatmentModal = () => {
  isNewTreatmentVisible.value = true;
};
const showEditTreatmentModals = (treatmentId) => {
  console.log("LICKED", treatmentId); // Log the treatment ID for debugging
  selectedTreatmentId.value = treatmentId; // Store the treatment ID
  isEditTreatmentVisible.value = true; // Show the dialog
};
const showAddMedicalImageModal = () => {
  isNewMedicalImageVisible.value = true;
  eventBus.emit("newTestResultAdded");
};
const handleNewTreatment = () => {
  isNewTreatmentVisible.value = false;
  eventBus.emit("newTreatmentAdded");
};
const handleUpdatedTreatment = () => {
  isEditTreatmentVisible.value = false;
  eventBus.emit("TreatmentUpdatedSuccessfully");
};
const handleMedicalImageUpdated = () => {
  isEditMedicalImageVisible.value = false;
  eventBus.emit("MedicalImageUpdatedSuccessfully");
};
const handleTestResultUpdated = () => {
  isEditTestResultsVisible.value = false;
  eventBus.emit("handleTestResultUpdatedSuccessfully");
};
const handleCaseHistory = () => {
  // isCaseHistorysVisible.value = false;
  eventBus.emit("handleCaseHistorySuccessfully");
};
const showAddTestResultModal = () => {
  isNewTestResultVisible.value = true;
};
const showEditTestResultModal = (testresultId) => {
  selectedTestResultId.value = testresultId;
  isEditTestResultsVisible.value = true;
};
const showCaseHistoryModal = (MedicalRecordId) => {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // isAddCaseHistorysVisible.value = true;
  isCaseHistorysVisible.value = true;
};
const showPhysicalExaminationModal = (MedicalRecordId) => {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // isAddCaseHistorysVisible.value = true;
  isPhysicalExamination.value = true;
};
const showFullReportModal = (MedicalRecordId) => {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // isAddCaseHistorysVisible.value = true;
  isFullReportVisible.value = true;
};
const showAddInvoice = (MedicalRecordId) => {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // isAddCaseHistorysVisible.value = true;
  fetchInvoice().then(() => {
    viewDialogVisible.value = true;
  });
};

const showAddPhysicalExaminationModal = (MedicalRecordId) => {
  medical_record_id.value = MedicalRecordId;

  // isAddCaseHistorysVisible.value = true;
  isAddPhysicalExamination.value = true;
};
const handleAddInvoiceRequest = () => {
  // medical_record_id.value = MedicalRecordId;
  // isAddCaseHistorysVisible.value = true;
  viewDialogVisible.value = false;
  console.log("PET", medical_record_id.value);
  isModalVisible.value = true;
};
const handleAddPaymentRequest = () => {
  // medical_record_id.value = MedicalRecordId;
  // isAddCaseHistorysVisible.value = true;
  viewDialogVisible.value = false;
  console.log("PET", medical_record_id.value);
  // paymentDialogVisible.value = true;
  fetchInvoice().then(() => {
    paymentDialogVisible.value = true;
  });
};
const showAddCaseHistoryModal = (MedicalRecordId) => {
  // selectedTestResultId.value = testresultId;
  medical_record_id.value = MedicalRecordId;
  isAddCaseHistorysVisible.value = true;
  // isCaseHistorysVisible.value = true;
};
const showEditMedicalImageModal = (medicalImageId) => {
  selectedMedicalImageId.value = medicalImageId;
  console.log(selectedMedicalImageId);
  isEditMedicalImageVisible.value = true;
};
const handleNewTestResult = () => {
  isNewTestResultVisible.value = false;
  eventBus.emit("newTestResultAdded");
};
const handleSubmit = (data) => {
  console.log(data);
  isNewApointmentVisible.value = false;
  // currentPage.value = 1; // Reset to the first page when searching
  fetchPets();
  // fetchAppointments();
};
const handleInvoiceSubmit = (data) => {
  console.log(data);
  isModalVisible.value = false;
  // currentPage.value = 1; // Reset to the first page when searching
  fetchPets();
  // fetchAppointments();
};
const handleDetailsUpdated = (data) => {
  console.log(data);
  isEditPetDetailsVisible.value = false;
  fetchPets();
};
const handleSubmitNewImage = (data) => {
  console.log(data);
  isNewMedicalImageVisible.value = false;
  eventBus.emit("newImageAdded");

  // currentPage.value = 1; // Reset to the first page when searching

  // fetchAppointments();
};

const addAppointment = () => {
  console.log(petmicrochip.value);
  isNewApointmentVisible.value = true;
};
const handleAppointmentUpdated = (data) => {
  console.log("Appointment updated:", data);
  isEditApointmentVisible.value = false;
  fetchPets();
  // Refresh the appointments list or perform other actions
};
const handlePaymentSubmit = () => {
  paymentDialogVisible.value = false;
  fetchPets();
};
const editPetDetails = () => {
  console.log(petmicrochip.value);
  isEditPetDetailsVisible.value = true;
};
const refreshData = () => {
  // loading.value = true; // Set loading state to true to show skeletons
  fetchPets(); // Fetch the pets data again
};
// console.log(pet.value);
const owner = ref(""); // Initialize owner as an empty string
const loading = ref(true);
const visits = ref([]);
const medical_records = ref([]);
const medical_record_id = ref("");
const appointment_id = ref("");
const species = ref([
  { label: "Avian", value: "Birds", icon: "fa-solid fa-dove" },
  { label: "Bovine", value: "Cows", icon: "fa-solid fa-cow" },
  { label: "Camelid", value: "Camels", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Canine", value: "Dogs", icon: "fa-solid fa-dog" },
  { label: "Caprine", value: "Goats", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Cavies", value: "Guinea Pigs", icon: "fa-solid fa-paw" }, // Default icon
  { label: "Cervidae", value: "Deers", icon: "fa-solid fa-paw" },
  { label: "Equine", value: "Horses", icon: "fa-duotone fa-horse " },
  { label: "Feline", value: "Cats", icon: "fa-solid fa-cat" },
  { label: "Lapine", value: "Rabbits", icon: "fa-solid fad fa-rabbit" },
  { label: "Murine", value: "Mice", icon: "fa-solid fa-paw" },
  { label: "Ovine", value: "Sheeps", icon: "fa-solid fa-sheep" },
]);

function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.label === speciesLabel);
  return found ? found.icon : "fa-solid fa-paw";
}
const parseResults = (resultsString) => {
  if (!resultsString) return []; // Return an empty array if input is null or undefined
  try {
    // Directly parse the JSON array
    const results = JSON.parse(resultsString);

    // Ensure results is an array of strings
    if (Array.isArray(results) && results.every((item) => typeof item === "string")) {
      return results.map((result) => result.trim()); // Trim whitespace from each string
    } else {
      console.error("Unexpected data format:", results);
      return [];
    }
  } catch (error) {
    console.error("Error parsing results:", error);
    return [];
  }
};
const getSpeciesValue = (label) => {
  const found = species.value.find((species) => species.label === label);
  return found ? found.value : null;
};
const eventTheme = {
  Regular: {
    colorName: "Regular",
    lightColors: {
      main: "#f9d71c",
      container: "#fff5aa",
      onContainer: "#594800",
    },
    darkColors: {
      main: "#fff5c0",
      onContainer: "#fff5de",
      container: "#a29742",
    },
  },
  Emergency: {
    colorName: "Emergency",
    lightColors: {
      main: "#f91c45",
      container: "#ffd2dc",
      onContainer: "#59000d",
    },
    darkColors: {
      main: "#ffc0cc",
      onContainer: "#ffdee6",
      container: "#a24258",
    },
  },
  FollowUp: {
    colorName: "FollowUp",
    lightColors: {
      main: "#1cf9b0",
      container: "#dafff0",
      onContainer: "#004d3d",
    },
    darkColors: {
      main: "#c0fff5",
      onContainer: "#e6fff5",
      container: "#42a297",
    },
  },
  Surgery: {
    colorName: "Surgery",
    lightColors: {
      main: "#1c7df9",
      container: "#d2e7ff",
      onContainer: "#002859",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
  Grooming: {
    colorName: "Grooming",
    lightColors: {
      main: "#8A2BE2",
      container: "#E6D6FF",
      onContainer: "#3E0071",
    },
    darkColors: {
      main: "#c0dfff",
      onContainer: "#dee6ff",
      container: "#426aa2",
    },
  },
};
// Function to compute the age of the pet in years and months
const computeAge = (dateOfBirth) => {
  const birthDate = new Date(dateOfBirth);
  const currentDate = new Date();
  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth();
  const birthYear = birthDate.getFullYear();
  const birthMonth = birthDate.getMonth();

  let ageInYears = currentYear - birthYear;
  let ageInMonths = currentMonth - birthMonth;

  // Adjust for case where the current month is less than the birth month
  if (ageInMonths < 0) {
    ageInYears--;
    ageInMonths += 12; // Adding 12 because it's a full year back
  }

  // Construct the age string
  const yearsText = ageInYears > 0 ? `${ageInYears} ${ageInYears > 1 ? "Y" : "Y"}` : "";
  const monthsText =
    ageInMonths > 0 ? `${ageInMonths} ${ageInMonths > 1 ? "M" : "M"}` : "";

  // Combine them into a single string, handling cases where there are no months or no years
  return `${yearsText}${yearsText && monthsText ? " & " : ""}${monthsText}`;
};
// // console.log(petmicrochip.value);
const fetchPets = async () => {
  loading.value = true;
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(`/pets/${petmicrochip.value}`);
    pet.value = response.data;
    console.log(pet.value);
    visits.value = response.data.appointments;
    medical_records.value = response.data.medical_records;
    pet.value.date_of_birth = formatDateForSubmission(pet.value.date_of_birth);
    owner.value = pet.value.length > 0 ? pet.value[0].owner.name : "Unknown Owner"; // Set owner name if pets exist
    loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};
const fetchInvoice = async () => {
  // loading.value = true;
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/medical-records/${medical_record_id.value}/invoice`
    );
    selectedInvoice.value = response.data.data;
    console.log("selectedInvoice", selectedInvoice.value);
    // loading.value = false; // Stop loading once data is fetched
  } catch (error) {
    //     // showSuccess("warn", "Warning", "Couldent Fetch Data");
  } finally {
  }
};

const formatDateForSubmission = (dateString) => {
  const date = new Date(dateString);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(
    date.getDate()
  ).padStart(2, "0")}`;
};
function getEventTheme(themeName) {
  // // console.log(themeName);
  return eventTheme[themeName] || null; // Return the corresponding theme or null if not found
}
function listTreatments(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isTreatmentsListVisible.value = true;
}
function editAppointment(AppointmentID) {
  appointment_id.value = AppointmentID;
  console.log("MEDIACAL" + AppointmentID);
  isEditApointmentVisible.value = true;
}
function listTestResults(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isTestResultsVisible.value = true;
}
function listImages(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isImagesListVisible.value = true;
}
const findRecordById = (id) => {
  return medical_records.value.find((record) => record.visit_date === id).id;
};

onMounted(() => {
  fetchPets();
  eventBus.on("showPaymentView", (event) => {
    viewDialogVisible.value = false;
    paymentDialogVisible.value = true;
    // console.log(event);
    // console.log("selectedInvoice", selectedInvoice);
  });
});
</script>
