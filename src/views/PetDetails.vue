<template>
  <div
    class="flex gap-2 h-[calc(100vh-60px)] lg:h-[calc(100vh-110px)] overflow-y-auto w-full"
  >
    <div
      class="w-1/4 h-fit bg-[var(--p-surface-100)] dark:bg-[var(--p-surface-800)] rounded-lg"
    >
      <!--       <Card class="w-full">
        <template #header>
          <Button
            @click="router.go(-1)"
            class="p-button p-component p-button-icon-only !w-6 h-6 !text-xs m-2"
            icon="pi pi-arrow-left !text-xs"
            v-tooltip.top="{
              value: $t('pet_details.go_back'),
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
          <div v-else>{{ pet.name }}</div>
        </template>
        <template #subtitle>
          <div class="flex gap-4">
            <Skeleton v-if="loading" width="12rem" height="2rem" />
            <Chip
              v-else
              v-tooltip.top="{
                value: $t('pet_details.microchip'),
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
              class="lg:!text-xs !text-sm border"
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
            <Chip class="lg:!text-xs text-sm mt-2 border">
              <router-link
                :to="`/` + pet.owner.id + `/pets`"
                v-tooltip.top="{
                  value: $t('pet_details.view_patients'),
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

            <Chip class="lg:!text-xs text-sm mt-2 border">
              <i :class="getIconClass(pet.species)"></i>
              {{ $t(`pet_details.species.${getSpeciesValue(pet.species)}`) }}
            </Chip>
            <Chip
              class="lg:!text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: $t('pet_details.breed'),
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
              class="lg:!text-xs text-sm mt-2 border"
              v-if="pet.color !== null"
              v-tooltip.top="{
                value: $t('pet_details.color'),
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
              class="lg:!text-xs text-sm mt-2 border"
              v-if="pet.behaviour !== null"
              v-tooltip.top="{
                value: $t('pet_details.behavior') + ': ' + pet.behaviour,
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
            <Chip class="lg:!text-xs text-sm mt-2 border">
              <i
                class="fa-solid fa-venus !text-pink-600"
                v-if="pet.gender === `Female`"
              ></i>
              <i class="fa-solid fa-mars !text-blue-600" v-else></i>
              {{ $t(`pet_details.${pet.gender}`) }}
            </Chip>
            <Chip
              class="lg:!text-xs text-sm mt-2 p-button-success p-button-outlined"
              v-if="pet.neutered === 'Y'"
              v-tooltip.top="{
                value: $t('pet_details.neutered'),
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
              {{
                pet.gender === "Male"
                  ? $t("pet_details.neutered")
                  : $t("pet_details.neutered")
              }}
            </Chip>
            <Chip
              class="lg:!text-xs text-sm mt-2 p-button-danger p-button-outlined"
              v-else
              v-tooltip.top="{
                value: $t('pet_details.neutered'),
                pt: {
                  arrow: {
                    style: {
                      borderTopColor: 'var(--p-primary-color)',
                    },
                  },
                  text: '!bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md ',
                },
              }"
              >{{
                pet.gender === "Male"
                  ? $t("pet_details.not_neutered")
                  : $t("pet_details.not_spayed")
              }}</Chip
            >
            <Chip
              class="lg:!text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: $t('pet_details.age'),
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
              class="lg:!text-xs text-sm mt-2 border"
              v-tooltip.top="{
                value: $t('pet_details.birth_date'),
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
              class="lg:!text-xs text-sm mt-2"
              :class="
                `` + pet.deceased === 'Y'
                  ? `!bg-black !text-white`
                  : `!bg-green-500 !text-white`
              "
            >
              <i v-if="pet.deceased === 'Y'" class="fa-solid fa-heart-crack"></i>
              <i v-else class="fa-solid fa-heart"></i>
              {{
                pet.deceased === "Y"
                  ? $t("pet_details.deceased")
                  : $t("pet_details.alive")
              }}
              {{
                pet.deceased === "Y" && pet.date_of_morta !== null
                  ? ": " + pet.date_of_morta
                  : ": YES"
              }}
            </Chip>
            <Chip
              v-if="pet.allergies !== null"
              class="lg:!text-xs text-sm mt-2 p-button-danger p-button-outlined"
              v-tooltip.top="{
                value: $t('pet_details.allergies') + ': ' + pet.allergies,
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
            <Chip
              class="lg:!text-xs text-sm mt-2 cursor-pointer"
              v-tooltip.top="{
                value: $t('pet_details.distinctive_marks'),
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
              :label="$t('pet_details.edit')"
              v-tooltip.bottom="$t('pet_details.edit')"
              class="lg:!text-xs mt-2 cursor-pointer !bg-[var(--p-primary-color)] !font-thin !text-xs shadow-md"
              @click="editPetDetails"
            />
          </div>
        </template>
        <template #footer>
          <div class="flex gap-4 mt-1">

          </div>
        </template>
      </Card>
 -->
      <Card
        class="w-full h-full shadow-lg rounded-xl !overflow-hidden border border-[#c4c7c5] dark:!border-[#444746]"
      >
        <template #header>
          <div
            class="relative md:h-20 2xl:h-40 bg-gradient-to-br"
            :class="
              pet.gender === 'Female'
                ? 'from-purple-100 to-red-100 dark:from-purple-800 dark:to-red-800'
                : 'from-indigo-100 to-blue-100 dark:from-purple-800 dark:to-blue-800'
            "
          >
            <Button
              @click="router.go(-1)"
              class="relative top-3 right-3 left-3 p-button-text p-button-rounded !text-gray-600 dark:!text-gray-200 hover:!bg-gray-100 dark:hover:!bg-gray-700 z-10"
              :icon="isRtl ? 'pi pi-arrow-right' : 'pi pi-arrow-left'"
              v-tooltip.top="$t('pet_details.go_back')"
            />
            <div class="absolute inset-0 flex items-center justify-center">
              <i class="fas fa-paw text-6xl text-white opacity-70"></i>
            </div>
            <div v-if="pet.deceased === 'Y'" class="absolute bottom-3 right-3 left-3">
              <Tag
                value="Deceased"
                severity="danger"
                class="!text-xs font-medium"
                icon="fa-solid fa-heart-crack"
              />
            </div>
          </div>
        </template>

        <template #title>
          <div class="flex items-center justify-between">
            <Skeleton v-if="loading" width="12rem" height="2rem" />
            <template v-else>
              <h2 class="text-xl font-semibold text-gray-800 dark:text-white">
                {{ pet.name }}
              </h2>
              <Tag
                :value="$t(`pet_details.${pet.gender}`)"
                :severity="pet.gender === 'Female' ? 'danger' : 'success'"
                class="!text-xs"
                :icon="pet.gender === 'Female' ? 'fa-solid fa-venus' : 'fa-solid fa-mars'"
              />
            </template>
          </div>
        </template>

        <template #subtitle>
          <div class="flex items-center gap-2 mt-1">
            <Skeleton v-if="loading" width="12rem" height="1.5rem" />
            <template v-else>
              <Tag
                :value="pet.microchip_num"
                icon="fas fa-microchip"
                class="!text-xs bg-gray-200 dark:bg-gray-700 text-gray-600 dark:text-gray-200"
              />
            </template>
          </div>
        </template>

        <template #content>
          <div v-if="loading" class="space-y-3">
            <Skeleton width="100%" height="1.5rem" />
            <Skeleton width="100%" height="1.5rem" />
            <Skeleton width="70%" height="1.5rem" />
          </div>

          <div v-else class="space-y-2 mt-1">
            <!-- Owner Section -->
            <div class="bg-gray-200 dark:bg-gray-700 p-3 rounded-lg">
              <h3
                class="text-xs font-medium text-gray-500 dark:text-gray-300 mb-2 flex items-center gap-2"
              >
                <i class="fas fa-user"></i>
                {{ $t("pets.columns.owner") }}
              </h3>
              <router-link
                :to="`/${pet.owner.id}/pets`"
                class="text-indigo-600 dark:text-indigo-400 hover:text-indigo-800 dark:hover:text-indigo-300 font-medium flex items-center gap-1"
              >
                {{ pet.owner.name }}
                <i class="pi pi-external-link text-xs"></i>
              </router-link>
            </div>

            <!-- Pet Details Section -->
            <div class="bg-gray-200 dark:bg-gray-700 p-3 rounded-lg">
              <h3
                class="text-xs font-medium text-gray-500 dark:text-gray-300 mb-2 flex items-center gap-2"
              >
                <i class="fas fa-paw"></i>
                {{ $t("pet_details.title") }}
              </h3>
              <div class="grid grid-cols-2 gap-2 text-sm">
                <div>
                  <p class="text-gray-500 dark:text-gray-400 text-xs">
                    {{ $t("pet_details.species_header") }}
                  </p>
                  <p class="flex items-center gap-1">
                    <i :class="getIconClass(pet.species)"></i>
                    {{ getSpeciesValue(pet.species) }}
                  </p>
                </div>
                <div>
                  <p class="text-gray-500 dark:text-gray-400 text-xs">
                    {{ $t("pet_details.breed") }}
                  </p>
                  <p>{{ pet.breed || "-" }}</p>
                </div>
                <div>
                  <p class="text-gray-500 dark:text-gray-400 text-xs">
                    {{ $t("pet_details.color") }}
                  </p>
                  <p class="flex items-center gap-1">
                    <i class="fa-solid fa-palette text-gray-400"></i>
                    {{ pet.color || "-" }}
                  </p>
                </div>
                <div>
                  <p class="text-gray-500 dark:text-gray-400 text-xs">
                    {{ $t("pet_details.age") }}
                  </p>
                  <p class="flex items-center gap-1">
                    <i class="fa-solid fa-cake-candles text-gray-400"></i>
                    {{ computeAge(pet.date_of_birth) }}
                  </p>
                </div>
              </div>
            </div>

            <!-- Medical Info Section -->
            <div class="bg-gray-200 dark:bg-gray-700 p-3 rounded-lg">
              <h3
                class="text-xs font-medium text-gray-500 dark:text-gray-300 mb-2 flex items-center gap-2"
              >
                <i class="fas fa-heartbeat"></i>
                {{ $t("pet_details.medical_info") }}
              </h3>
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <span class="text-gray-500 dark:text-gray-400 text-xs"
                    >{{ $t("pet_details.neutered") }}:</span
                  >
                  <Tag
                    :value="
                      pet.neutered === 'Y'
                        ? pet.gender === 'Male'
                          ? $t('pet_details.neutered')
                          : $t('pet_details.spayed')
                        : pet.gender === 'Male'
                        ? $t('pet_details.not_neutered')
                        : $t('pet_details.not_spayed')
                    "
                    :severity="pet.neutered === 'Y' ? 'success' : 'danger'"
                    class="!text-xs"
                  />
                </div>
                <div v-if="pet.allergies" class="flex items-start gap-2">
                  <span class="text-gray-500 dark:text-gray-400 text-xs"
                    >{{ $t("pet_details.allergies") }}:</span
                  >
                  <Tag icon="fas fa-disease" severity="warning" class="!text-xs">
                    {{ pet.allergies }}
                  </Tag>
                </div>
                <div v-if="pet.behaviour" class="flex items-center gap-2">
                  <span class="text-gray-500 dark:text-gray-400 text-xs"
                    >{{ $t("pet_details.behavior") }}:</span
                  >
                  <span class="flex items-center gap-1">
                    <i class="fa-solid fa-face-angry text-gray-400"></i>
                    {{ pet.behaviour }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Additional Info -->
            <div
              v-if="pet.distinctive_marks"
              class="bg-gray-200 dark:bg-gray-700 p-3 rounded-lg"
            >
              <h3
                class="text-xs font-medium text-gray-500 dark:text-gray-300 mb-2 flex items-center gap-2"
              >
                <i class="fas fa-asterisk"></i>
                {{ $t("pet_details.distinctive_marks") }}
              </h3>
              <p class="text-sm">{{ pet.distinctive_marks }}</p>
            </div>
          </div>
        </template>

        <template #footer>
          <div class="flex justify-end">
            <Button
              icon="fa-solid fa-pencil"
              :label="$t('pet_details.edit')"
              class="!text-xs !py-2 !px-4"
              @click="editPetDetails"
            />
          </div>
        </template>
      </Card>
    </div>
    <div
      class="w-3/4 min-h-full bg-[var(--p-surface-100)] dark:bg-[var(--p-surface-800)] rounded-[10px] overflow-hidden border border-[#c4c7c5] dark:!border-[#444746]"
    >
      <DataTable
        showGridlines
        :value="visits"
        scrollable
        scrollHeight="80vh"
        class="text-xs"
        stripedRows
        v-if="!loading"
        :paginator="true"
        :rows="itemsPerPage"
        :totalRecords="visits.length"
        :first="0"
        @page="onPageChange"
        :rowsPerPageOptions="[25, 50, 100]"
      >
        <template #header>
          <div class="flex flex-wrap items-center justify-between gap-2">
            <span class="lg:text-sm text-lg font-bold">{{
              $t("pet_details.visits_history")
            }}</span>
            <div class="flex gap-2">
              <Button
                v-tooltip.bottom="$t('pet_details.add_appointment')"
                icon="pi pi-plus"
                @click="addAppointment"
                class="p-button p-button-icon-only !text-sm !font-thin h-8"
              />
              <Button
                type="button"
                icon="pi pi-refresh !text-sm"
                label=""
                v-tooltip.bottom="$t('pet_details.refresh_data')"
                class="p-button p-button-icon-only !text-sm !font-thin h-8"
                @click="refreshData"
              />
            </div>
          </div>
        </template>
        <Column
          field="start"
          :header="$t('pet_details.date')"
          :class="`text-center ltr w-1/8 lg:!text-[14px] text-xs justify-center`"
        ></Column>
        <Column
          field="title"
          :header="$t('pet_details.description')"
          class="font-normal lg:!text-[14px] text-xs !rtl"
        >
        </Column>

        <Column
          field="description"
          :header="$t('pet_details.description')"
          class="font-normal lg:!text-[14px] text-xs rtl:!text-right"
        >
          <template #body="slotProps">
            <div
              class="gap-2 px-1"
              v-html="slotProps.data.description.replace(/\n/g, '<br />')"
            ></div>
          </template>
        </Column>
        <Column field="type" :header="$t('pet_details.type')">
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
                <span class="lg:!text-[14px] text-xs whitespace-nowrap font-normal">{{
                  $t(`calendar.appointment.${slotProps.data.type.toLowerCase()}`)
                }}</span>
              </div>
            </Tag>
          </template>
        </Column>
        <Column class="w-fit whitespace-nowrap">
          <template #body="slotProps">
            <Button
              type="button"
              icon="fa-solid fa-syringe"
              v-tooltip.top="{
                value: $t('pet_details.view_treatments'),
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
                value: $t('pet_details.view_tests'),
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
                value: $t('pet_details.xray_ultrasound'),
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
                value: $t('pet_details.case_history'),
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
                value: $t('pet_details.medical_examination'),
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
                value: $t('pet_details.full_report'),
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
                value: $t('pet_details.invoice'),
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
                value: $t('pet_details.edit_details'),
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
        <!-- <template #footer>
          {{ $t("pet_details.total_records", { count: visits ? visits.length : 0 }) }}
        </template> -->
        <!-- <template #footer>
          <Paginator
            :rows="itemsPerPage"
            :first="0"
            :totalRecords="visits.length"
            :currentPage="currentPage"
            :rowsPerPageOptions="[5, 25, 50, 100]"
            @page="onPageChange"
            class="!rounded-b-xl text-xs"
          ></Paginator>
        </template> -->
      </DataTable>
    </div>
  </div>
  <Dialog
    v-model:visible="isTreatmentsListVisible"
    @hide="isTreatmentsListVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.treatments")
        }}</span>
      </div>
    </template>
    <PetTreatments
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showAddTreatmentModal="showAddTreatmentModal"
      @showEditTreatmentModal="showEditTreatmentModals"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.edit_pet_details')"
    v-model:visible="isEditPetDetailsVisible"
    @hide="isEditPetDetailsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.edit_pet_details")
        }}</span>
      </div>
    </template>
    <EditPetDetails
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showEditPetDetailsModal="showEditPetDetailsModal"
      @details_updated="handleDetailsUpdated"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.edit_treatment')"
    v-model:visible="isEditTreatmentVisible"
    @hide="isEditTreatmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.edit_treatment")
        }}</span>
      </div>
    </template>
    <EditTreatment
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      @TreatmentUpdated="handleUpdatedTreatment"
      :treatmentId="selectedTreatmentId"
      :medical_record_id="medical_record_id"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.test_results')"
    v-model:visible="isTestResultsVisible"
    @hide="isTestResultsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.test_results")
        }}</span>
      </div>
    </template>
    <TestResults
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showAddTestResultModal="showAddTestResultModal"
      @showEditTestResultModal="showEditTestResultModal"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.medical_image')"
    v-model:visible="isEditMedicalImageVisible"
    @hide="isEditMedicalImageVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.test_results")
        }}</span>
      </div>
    </template>
    <EditMedicalImage
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      @MedicalImageUpdated="handleMedicalImageUpdated"
      :medicalImageId="selectedMedicalImageId"
      :medical_record_id="medical_record_id"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.xrays_images')"
    v-model:visible="isImagesListVisible"
    @hide="isImagesListVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.xrays_images")
        }}</span>
      </div>
    </template>
    <MedicalImages
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showAddMedicalImageModal="showAddMedicalImageModal"
      @showEditMedicalImageModal="showEditMedicalImageModal"
    />
    <template #footer> </template>
  </Dialog>

  <!-- Add Medical Image Modal -->
  <Dialog
    :header="$t('pet_details.new_medical_image')"
    v-model:visible="isNewMedicalImageVisible"
    @hide="isNewMedicalImageVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.new_medical_image")
        }}</span>
      </div>
    </template>
    <AddNewMedicalImage
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @NewImageAdded="handleSubmitNewImage"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.new_treatment')"
    v-model:visible="isNewTreatmentVisible"
    @hide="isNewTreatmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.new_treatment")
        }}</span>
      </div>
    </template>
    <AddNewTreatment
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @TreatmentAdded="handleNewTreatment"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.new_test_result')"
    v-model:visible="isNewTestResultVisible"
    @hide="isNewTestResultVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.new_test_result")
        }}</span>
      </div>
    </template>
    <AddNewTestResult
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @TestResultAdded="handleNewTestResult"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.new_record')"
    v-model:visible="isNewApointmentVisible"
    @hide="isNewApointmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.new_record")
        }}</span>
      </div>
    </template>
    <AddNewAppointment
      v-focustrap="{
        disabled: false,
      }"
      :petMicrochip="petmicrochip"
      :petOwnerID="pet.owner.id"
      @submitted="handleSubmit"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.edit_record')"
    v-model:visible="isEditApointmentVisible"
    @hide="isEditApointmentVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.edit_record")
        }}</span>
      </div>
    </template>
    <EditAppointment
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :appointmentId="appointment_id"
      @updated="handleAppointmentUpdated"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.edit_test_result')"
    v-model:visible="isEditTestResultsVisible"
    @hide="isEditTestResultsVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-6/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.edit_test_result")
        }}</span>
      </div>
    </template>
    <EditTestResult
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :testResultId="selectedTestResultId"
      @TestResultUpdated="handleTestResultUpdated"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.add_case_history')"
    v-model:visible="isAddCaseHistorysVisible"
    @hide="isAddCaseHistorysVisible = false"
    modal
    :closable="true"
    class="w-10/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.add_case_history")
        }}</span>
      </div>
    </template>
    <AddCaseHistory
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      :pet_neutered="pet.neutered"
      @TestResultUpdated="handleTestResultUpdated"
      @CaseHistoryCreated="handleCaseHistoryAdded"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.case_history')"
    v-model:visible="isCaseHistorysVisible"
    @hide="isCaseHistorysVisible = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.case_history")
        }}</span>
      </div>
    </template>
    <CaseHistory
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showAddCaseHistoryModal="showAddCaseHistoryModal"
      @CaseHistoryUpdated="handleCaseHistory"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.add_physical_examination')"
    v-model:visible="isAddPhysicalExamination"
    @hide="isAddPhysicalExamination = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.add_physical_examination")
        }}</span>
      </div>
    </template>
    <AddPhysicalExamination
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      @showAddCaseHistoryModal="showAddCaseHistoryModal"
      @CaseHistoryUpdated="handleCaseHistory"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.physical_examination')"
    v-model:visible="isPhysicalExamination"
    @hide="isPhysicalExamination = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.physical_examination")
        }}</span>
      </div>
    </template>
    <PhysicalExamination
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      :pet_name="pet.name"
      :branch_name="pet.branch.name"
      @showAddPhysicalExaminationModal="showAddPhysicalExaminationModal"
      @PhysicalExaminationUpdated="handlePhysicalExamination"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <Dialog
    :header="$t('pet_details.full_report')"
    v-model:visible="isFullReportVisible"
    @hide="isFullReportVisible = false"
    modal
    :closable="true"
    class="w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)] mx-auto"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.full_report")
        }}</span>
      </div>
    </template>
    <FullReport
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :medical_record_id="medical_record_id"
      :pet_name="pet.name"
      @showAddPhysicalExaminationModal="showAddPhysicalExaminationModal"
      @close-dialog="isEditTestResultsVisible = false"
    />
    <template #footer> </template>
  </Dialog>
  <!-- View Invoice Dialog -->
  <Dialog
    :header="$t('pet_details.invoice_details')"
    v-model:visible="viewDialogVisible"
    modal
    :closable="true"
    class="w-11/12 md:w-8/12 bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <InvoiceView
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :invoice="selectedInvoice"
      @addInvoice="handleAddInvoiceRequest"
      @addPayment="handleAddPaymentRequest"
    />
  </Dialog>

  <Dialog
    :header="$t('pet_details.create_invoice')"
    v-model:visible="isModalVisible"
    @hide="isModalVisible = false"
    modal
    :closable="true"
    class="w-11/12 md:w-11/12 h-screen bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.create_invoice")
        }}</span>
      </div>
    </template>
    <InvoiceAdd
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      :pet="pet"
      :medical_record_id="medical_record_id"
      @InvoiceCreated="handleInvoiceSubmit"
    />
  </Dialog>
  <Dialog
    :header="$t('pet_details.add_payment')"
    v-model:visible="paymentDialogVisible"
    @hide="resetForm"
    modal
    :closable="true"
    class="w-[11/12] md:w-[500px] h-fit bg-[var(--p-surface-400)] dark:bg-[var(--p-surface-800)]"
  >
    <template #header>
      <div class="inline-flex items-center justify-center gap-2 h-4">
        <span class="font-bold whitespace-nowrap">{{
          $t("pet_details.add_payment")
        }}</span>
      </div>
    </template>
    <AddPayment
      v-focustrap="{
        disabled: false,
        autoFocus: true,
      }"
      v-if="selectedInvoice"
      :invoice="selectedInvoice"
      :paymentMethods="paymentMethods"
      @submit="handlePaymentSubmit"
      @cancel="paymentDialogVisible = false"
    />
  </Dialog>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import { useI18n } from "vue-i18n";
import Card from "primevue/card";
import Chip from "primevue/chip";
import router from "@/router";
import { useRoute } from "vue-router";
import Tag from "primevue/tag";
import Button from "primevue/button";
import eventBus from "@/eventBus";
import axiosInstance from "@/axios";
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import Skeleton from "primevue/skeleton";
import Dialog from "primevue/dialog";
import PetTreatments from "@/views/TreatmentsList.vue";
import TestResults from "@/views/TestResults.vue";
import AddNewTreatment from "@/views/AddNewTreatment.vue";
import AddNewTestResult from "@/views/AddNewTestResult.vue";
import AddNewAppointment from "@/views/addNewAppointment.vue";
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
// import Paginator from "primevue/paginator";

const { t } = useI18n();
const emit = defineEmits([]);
const itemsPerPage = ref(25);
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
const currentPage = ref(1);
const isRtl = document.getElementsByTagName("html")[0].dir === "rtl" ? true : false;
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
  // console.log("LICKED", treatmentId); // Log the treatment ID for debugging
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
const handlePhysicalExamination = () => {
  isPhysicalExamination.value = false;
  eventBus.emit("PhysicalExaminationUpdatedSuccessfully");
};
const handleTestResultUpdated = () => {
  isEditTestResultsVisible.value = false;
  eventBus.emit("handleTestResultUpdatedSuccessfully");
};
const handleCaseHistory = () => {
  // isCaseHistorysVisible.value = false;
  eventBus.emit("handleCaseHistorySuccessfully");
};
const handleCaseHistoryAdded = () => {
  isAddCaseHistorysVisible.value = false;
  isCaseHistorysVisible.value = false;
  fetchPets();
  // eventBus.emit("handleCaseHistorySuccessfully");
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
  // console.log("PET", medical_record_id.value);
  isModalVisible.value = true;
};
// const handleInvoiceSubmit = () => {
//   // medical_record_id.value = MedicalRecordId;
//   // isAddCaseHistorysVisible.value = true;
//   viewDialogVisible.value = false;
//   // console.log("PET", medical_record_id.value);
//   isModalVisible.value = true;
// };
const handleAddPaymentRequest = () => {
  // medical_record_id.value = MedicalRecordId;
  // isAddCaseHistorysVisible.value = true;
  viewDialogVisible.value = false;
  // console.log("PET", medical_record_id.value);
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
  // console.log(selectedMedicalImageId);
  isEditMedicalImageVisible.value = true;
};
const handleNewTestResult = () => {
  isNewTestResultVisible.value = false;
  eventBus.emit("newTestResultAdded");
};
const handleSubmit = (data) => {
  // console.log(data);
  isNewApointmentVisible.value = false;
  // currentPage.value = 1; // Reset to the first page when searching
  fetchPets();
  // fetchAppointments();
};
const handleInvoiceSubmit = (data) => {
  // console.log(data);
  isModalVisible.value = false;
  fetchPets();
  // fetchAppointments();
};
const handleDetailsUpdated = (data) => {
  // console.log(data);
  isEditPetDetailsVisible.value = false;
  fetchPets();
};
const handleSubmitNewImage = (data) => {
  // console.log(data);
  isNewMedicalImageVisible.value = false;
  eventBus.emit("newImageAdded");

  // currentPage.value = 1; // Reset to the first page when searching

  // fetchAppointments();
};

const addAppointment = () => {
  // console.log(petmicrochip.value);
  isNewApointmentVisible.value = true;
};
const handleAppointmentUpdated = (data) => {
  // console.log("Appointment updated:", data);
  isEditApointmentVisible.value = false;
  fetchPets();
  // Refresh the appointments list or perform other actions
};
const handlePaymentSubmit = () => {
  paymentDialogVisible.value = false;
  fetchPets();
};
const editPetDetails = () => {
  // console.log(petmicrochip.value);
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
  {
    label: t("species.avian"),
    en_label: "Avian",
    value: "Birds",
    icon: "fa-solid fa-dove",
  },
  {
    label: t("species.bovine"),
    en_label: "Bovine",
    value: "Cows",
    icon: "fa-solid fa-cow",
  },
  {
    label: t("species.camelid"),
    en_label: "Camelid",
    value: "Camels",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.canine"),
    en_label: "Canine",
    value: "Dogs",
    icon: "fa-solid fa-dog",
  },
  {
    label: t("species.caprine"),
    en_label: "Caprine",
    value: "Goats",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.cavies"),
    en_label: "Cavies",
    value: "Guinea Pigs",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.cervidae"),
    en_label: "Cervidae",
    value: "Deers",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.equine"),
    en_label: "Equine",
    value: "Horses",
    icon: "fa-duotone fa-horse",
  },
  {
    label: t("species.feline"),
    en_label: "Feline",
    value: "Cats",
    icon: "fa-solid fa-cat",
  },
  {
    label: t("species.lapine"),
    en_label: "Lapine",
    value: "Rabbits",
    icon: "fa-solid fad fa-rabbit",
  },
  {
    label: t("species.murine"),
    en_label: "Murine",
    value: "Mice",
    icon: "fa-solid fa-paw",
  },
  {
    label: t("species.ovine"),
    en_label: "Ovine",
    value: "Sheeps",
    icon: "fa-solid fa-sheep",
  },
]);

function getIconClass(speciesLabel) {
  const found = species.value.find((spec) => spec.en_label === speciesLabel);
  return found ? found.label : "fa-solid fa-paw";
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
  // console.log(label);
  const found = species.value.find((species) => species.en_label === label);
  return found ? found.label : null;
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
  "Non-Emergency": {
    colorName: "Non-Emergency",
    lightColors: {
      main: "#1db954", // Vibrant green (similar to Spotify's green)
      container: "#86e8b6", // Very light mint green
      onContainer: "#064e3b", // Dark green (for text on container)
    },
    darkColors: {
      main: "#a7f3d0", // Soft mint green
      onContainer: "#86e8b6", // Very light mint green
      container: "#065f46", // Deep emerald green
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
// console.log(petmicrochip.value);
const fetchPets = async () => {
  loading.value = true;
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(`/pets/${petmicrochip.value}`);
    pet.value = response.data;
    // console.log(response.data.appointments);
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
  try {
    // Make the request using the axios instance with interceptors
    const response = await axiosInstance.get(
      `/medical-records/${medical_record_id.value}/invoice`
    );
    selectedInvoice.value = response.data.data;
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
  // console.log(themeName);
  return eventTheme[themeName] || null; // Return the corresponding theme or null if not found
}
function listTreatments(MedicalRecordId) {
  medical_record_id.value = findRecordById(MedicalRecordId);
  // console.log("MEDIACAL" + medical_record_id.value);
  isTreatmentsListVisible.value = true;
}
function editAppointment(AppointmentID) {
  appointment_id.value = AppointmentID;
  // console.log("MEDIACAL" + AppointmentID);
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
const resetForm = () => {
  selectedInvoice.value = null;
  editMode.value = false;
};
function onPageChange(event) {
  first.value = event.first;
}
onMounted(() => {
  fetchPets();
  eventBus.on("showPaymentView", (event) => {
    viewDialogVisible.value = false;
    paymentDialogVisible.value = true;
  });
});
</script>
<style>
.text-center.ltr {
  text-align: center !important;
}
.text-center.ltr .p-datatable-column-header-content {
  justify-content: center;
}
.p-paginator.p-component {
  border-top-left-radius: 0px !important;
  border-top-right-radius: 0px !important;
  border-bottom-right-radius: 10px !important;
  border-bottom-left-radius: 10px !important;
}
.p-datatable {
  border-radius: 10px;
  overflow: hidden;
}
.p-datatable-gridlines .p-datatable-paginator-bottom,
.p-datatable-gridlines .p-datatable-header {
  border: 0 !important;
}
</style>
