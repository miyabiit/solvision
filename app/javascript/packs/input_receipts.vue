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
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <template v-for="(item, index) in formItems">
          <tr>
            <td :rowspan="item.receipts.length+1">{{ item.facilityName }}</td>
            <template v-for="(receipt, receiptIndex) in item.receipts" v-if="receiptIndex === 0">
              <td>
                <div class="ui input">
                  <input type="date" v-model="receipt.receiptDate" :min="beginningOfMonthDate"> 
                </div>
              </td>
              <td>
                <div class="ui input">
                  <input type="text" v-model="receipt.receiptFrom">
                </div>
              </td>
              <td class="number">
                <div class="ui input number">
                  <vue-numeric v-model="receipt.amount" separator="," :minus="false"></vue-numeric>
                </div>
                円
              </td>
              <td></td>
            </template>
          </tr>
          <tr v-for="(receipt, receiptIndex) in item.receipts" v-if="receiptIndex !== 0">
            <td>
              <div class="ui input">
                <input type="date" v-model="receipt.receiptDate" :min="beginningOfMonthDate"> 
              </div>
            </td>
            <td>
              <div class="ui input">
                <input type="text" v-model="receipt.receiptFrom">
              </div>
            </td>
            <td class="number">
              <div class="ui input number">
                <vue-numeric v-model="receipt.amount" separator="," :minus="false"></vue-numeric>
              </div>
              円
            </td>
            <td>
              <a href="javascript:void(0);" @click="removeReceipt(item, receiptIndex)">削除</a>
            </td>
          </tr>
          <tr>
            <td colspan="2" class="right aligned warning"><b>合計</b></td>
            <td class="right aligned warning">
              {{ sumAmount(item) | currency('', 0) }} 円
            </td>
            <td>
              <a href="javascript:void(0);" @click="addReceipt(item)">＋追加</a>
            </td>
          </tr>
        </template>
      </tbody>
    </table>
    <div>
      <button type="button" @click="updateReceipts()" class="ui primary button">更新</button>
    </div>
  </div>
</template>

<script>

import {MDCSelect} from '@material/select';
import * as moment from 'moment';

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
      monthlyReceipts: [],
      formItems: []
    }
  },
  mounted() {
    this.fetchReceipts()
  },
  computed: {
    beginningOfMonthDate() {
      return moment({year: this.selectedYear, month: this.selectedMonth-1, date: 1}).format('YYYY-MM-DD')
    },
    endOfMonthDate() {
      return moment({year: this.selectedYear, month: this.selectedMonth-1, date: 1}).endOf('month').format('YYYY-MM-DD')
    },
  },
  methods: {
    removeReceipt(item, receiptIndex) {
      item.receipts.splice(receiptIndex, 1)
    },
    addReceipt(item) {
      item.receipts.push({receiptFrom: '', receiptDate: '', amount: 0})
    },
    sumAmount(item) {
      let amount = 0
      for (const r of item.receipts) {
        amount += r.amount
      }
      return amount
    },
    regenerateFromItems() {
      let items = []
      for (const f of this.facilities)  {
        let item = {facilityId: f.id, facilityName: f.name, receipts: []}
        const receipt = this.monthlyReceipts.find((r) => r.facility_id === f.id)
        if (receipt && receipt.receipts && receipt.receipts.length > 0) {
          for (const r of receipt.receipts) {
            item.receipts.push({
              id: r.id,
              receiptFrom: r.receipt_from,
              receiptDate: r.receipt_date,
              amount: r.amount
            })
          }
        } else {
          item.receipts.push({receiptFrom: '', receiptDate: '', amount: 0})
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
        _this.monthlyReceipts = data.monthly_receipts
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
      let _this = this
      vbus.$emit('show-spinner')
      $.ajax({
          url: `/monthly_receipts/${this.year}/${this.month}`,
          type: "PUT",
          data: JSON.stringify({
            monthlyReceipts: this.formItems,
          }),
          contentType: 'application/json',
          dataType: 'json'
      })
      .done(( data ) => {
        _this.facilities = data.facilities
        _this.monthlyReceipts = data.monthly_receipts
        _this.regenerateFromItems()
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
