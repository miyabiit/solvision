/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import ApiTest from './api_test.vue'
import NavDrawer from './nav_drawer.vue'
import MessageBar from './message_bar.vue'
import Spinner from './spinner.vue'
import MonthPicker from './month_picker.vue'
import YearPicker from './year_picker.vue'
import InputReceipts from './input_receipts.vue'
import VueNumeric from 'vue-numeric'
import Vue2Filters from 'vue2-filters'
import VueC3 from 'vue-c3'
import ProjectGraph from './project_graph.vue'
import AnalysisIndex from './analysis_index.vue'
import InputKwModal from './input_kw_modal.vue'

Vue.component("api-test", ApiTest)
Vue.component("nav-drawer", NavDrawer)
Vue.component("message-bar", MessageBar)
Vue.component("spinner", Spinner)
Vue.component("month-picker", MonthPicker)
Vue.component("year-picker", YearPicker)
Vue.component("input-receipts", InputReceipts)
Vue.component("vue-numeric", VueNumeric)
Vue.component("vue-c3", VueC3)
Vue.component("project-graph", ProjectGraph)
Vue.component("analysis-index", AnalysisIndex)
Vue.component("input-kw-modal", InputKwModal)

Vue.use(Vue2Filters)

window.vbus = new Vue()
window.$vue_data = {}
window.Vue = Vue

document.addEventListener('DOMContentLoaded', () => {
  new Vue({ el: '#vue_root', data: window.$vue_data })
})

