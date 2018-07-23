<template>
  <div>
    <div class="mdc-select select-year" tabindex="0">
      <select v-model="selectedYear" class="mdc-select__native-control no-appearance">
        <option v-for="y in yearItems" :value="y">
          {{ y }}
        </option>
      </select>
    </div>
    年
    &nbsp;
    <div class="mdc-select select-month" tabindex="0">
      <select v-model="selectedMonth" class="mdc-select__native-control no-appearance">
        <option v-for="m in monthItems" :value="m">
          {{ m }}
        </option>
      </select>
    </div>
    月
  </div>
</template>

<script>
import {MDCSelect} from '@material/select'
import {MDCMenu} from '@material/menu'

const menuFactory = (menuEl) => {
  const menu = new MDCMenu(menuEl)
  return menu
}

export default {
  props: {
    year: Number,
    month: Number
  },
  data() {
    const today = new Date()
    const month = today.getFullYear()
    return {
      selectedYear: this.year,
      selectedMonth: this.month,
      yearItems: [month-1, month, month+1],
      monthItems: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    }
  },
  mounted() {
    var _this = this
    this.selects = []
  },
  watch: {
    selectedYear: function() { this.selectYear(this.selectedYear) },
    selectedMonth: function() { this.selectMonth(this.selectedMonth) },
  },
  methods: {
    selectYear(year) {
      this.$emit('changeYear', year) 
    },
    selectMonth(month) {
      this.$emit('changeMonth', month) 
    }
  }
}
</script>

<style scoped>
</style>
