<template>
  <div>
    <div class="mdc-layout-grid no-margin-grid">
      <div class="mdc-layout-grid__inner">
        <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-3">
          <month-picker :year="year" :month="month" @changeYear="onChangeYear" @changeMonth="onChangeMonth"></month-picker>
        </div>
      </div>
    </div>
    <table class="ui celled structured table">
      <thead>
        <tr>
          <th>発電施設</th>
          <th>入金日</th>
          <th>入金元</th>
          <th>入金金額</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(item, index) in formItems">
          <td>{{ item.facilityName }}</td>
          <td>
            <div class="ui input">
              <input type="date" v-model="item.receiptDate"> 
            </div>
          </td>
          <td>
            <div class="ui input">
              <input type="text" v-model="item.receiptFrom">
            </div>
          </td>
          <td class="number">
            <div class="ui input number">
              <vue-numeric v-model="item.amount" separator="," :minus="false"></vue-numeric>
            </div>
            円
          </td>
        </tr>
      </tbody>
    </table>
    <div>
      <button type="button" @click="updateReceipts()" class="ui primary button">更新</button>
    </div>
  </div>
</template>

<script>

import {MDCSelect} from '@material/select';

export default {
  props: {
    year: Number,
    month: Number,
    rootPath: {
      default: '/monthly_receipts',
      type: String
    }
  },
  data() {
    return {
      selectedYear: this.year,
      selectedMonth: this.month,
      facilities: [],
      receipts: [],
      formItems: []
    }
  },
  mounted() {
    this.fetchReceipts()
  },
  methods: {
    regenerateFromItems() {
      let items = []
      for (const f of this.facilities)  {
        let item = {facilityId: f.id, facilityName: f.name, amount: 0, receiptFrom: '', receiptDate: ''}
        const receipt = this.receipts.find((r) => r.facility_id === f.id)
        if (receipt) {
          item.amount = receipt.amount
          item.receiptFrom = receipt.receipt_from
          item.receiptDate = receipt.receipt_date
        }
        items.push(item)
      }
      this.formItems = items
    },
    fetchReceipts() {
      let _this = this
      vbus.$emit('show-spinner')
      $.ajax({
          url: `/monthly_receipts/${this.year}/${this.month}.json`,
          type: "GET",
          dataType: 'json'
      })
      .done(( data ) => {
        _this.facilities = data.facilities
        _this.receipts = data.receipts
        _this.regenerateFromItems()
      })
      .fail(( data ) => {
        vbus.$emit('show-message-bar', 'エラーが発生しました')
      })
      .always(( data ) => {
        vbus.$emit('hide-spinner')
      })
    },
    updateReceipts() {
      vbus.$emit('show-spinner')
      $.ajax({
          url: `/monthly_receipts/${this.year}/${this.month}`,
          type: "PUT",
          data: JSON.stringify({
            receipts: this.formItems,
          }),
          contentType: 'application/json',
          dataType: 'json'
      })
      .done(( data ) => {
        vbus.$emit('show-message-bar', '更新しました')
      })
      .fail(( data ) => {
        vbus.$emit('show-message-bar', 'エラーが発生しました')
      })
      .always(( data ) => {
        vbus.$emit('hide-spinner')
      })
    },
    reloadPage() {
      vbus.$emit('show-spinner')
      location.href = `${this.rootPath}/${this.selectedYear}/${this.selectedMonth}`
    },
    onChangeYear(year) {
      this.selectedYear = year
      this.reloadPage()
    },
    onChangeMonth(month) {
      this.selectedMonth = month
      this.reloadPage()
    },
  }
}
</script>
