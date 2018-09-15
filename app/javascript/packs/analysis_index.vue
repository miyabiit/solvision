<template>
  <div class="mdc-layout-grid no-margin-grid">
    <div class="mdc-layout-grid__inner">
      <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-3">
        <year-picker :year="year" @changeYear="onChangeYear"></year-picker>
      </div>
    </div>
  </div>
</template>

<script>

import {MDCSelect} from '@material/select';
import * as moment from 'moment';

export default {
  props: {
    year: Number,
    rootPath: {
      default: '/analysis',
      type: String
    }
  },
  data() {
    return {
      selectedYear: this.year,
      facilities: [],
      formItems: []
    }
  },
  methods: {
    reloadPage() {
      vbus.$emit('show-spinner')
      location.href = `${this.rootPath}/${this.selectedYear}`
    },
    onChangeYear(year) {
      this.selectedYear = year
      this.reloadPage()
    },
  }
}
</script>
