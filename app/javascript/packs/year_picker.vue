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
    year: Number
  },
  data() {
    const today = new Date()
    const startYear = 2016
    const year = today.getFullYear()
    let years = []
    for (let i = startYear; i <= year+1; ++i) {
      years.push(i)
    }
    return {
      selectedYear: this.year,
      yearItems: years,
    }
  },
  mounted() {
    var _this = this
    this.selects = []
  },
  watch: {
    selectedYear: function() { this.selectYear(this.selectedYear) },
  },
  methods: {
    selectYear(year) {
      this.$emit('changeYear', year) 
    },
  }
}
</script>

<style scoped>
</style>
