<template>
  <div v-if="displaySpinner">
    <div class="spinner-bg"></div>
    <svg class="spinner" width="65px" height="65px" viewBox="0 0 66 66" xmlns="http://www.w3.org/2000/svg">
      <circle class="path" fill="none" stroke-width="6" stroke-linecap="round" cx="33" cy="33" r="30"></circle>
    </svg>
  </div>
</template>

<script>
export default {
  data() {
    return {
      displaySpinner: false
    }
  },
  mounted() {
    vbus.$on('show-spinner', () => {this.show()})
    vbus.$on('hide-spinner', () => {this.hide()})
  },
  methods: {
    show() {
      this.displaySpinner = true
    },
    hide() {
      this.displaySpinner = false
    }
  }
}
</script>
