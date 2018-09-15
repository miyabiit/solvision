<template>
  <div>
    <vue-c3 :handler="handler"></vue-c3>
  </div>
</template>
<script>
import * as d3 from "d3"

export default {
  props: {
    xAxisType: String, // 'year' 横軸が年単位 / 'month' 横軸が月単位 / 'day' 横軸が日単位
    records: Array
  },
  data() {
    return {
      graphOptions: {},
      handler: new Vue()
    }
  },
  created() {
  },
  mounted() {
    this.createGraphDate()
    console.log(this.graphOptions)
    this.handler.$emit('init', this.graphOptions)
  },
  methods: {
    createGraphDate() {
      this.graphOptions = {
        data: {
          x: 'x',
          columns: [],
          types: {
            '発電量実績': 'bar',
            '発電量予測': 'bar'
          },
          axes: {
            '累積発電量実績': 'y2',
            '累積発電量予測': 'y2'
          }
        },
        axis: {
          y: {
            label: {
              text: 'kwh',
              position: 'outer-top'
            },
            tick: {
              format: d3.format(',')
            }
          },
          y2: {
            show: true,
            label: {
              text: 'kwh(累積)',
              position: 'outer-top'
            },
            tick: {
              format: d3.format(',')
            }
          }
        },
        color: {
          pattern: ['#ff7f0e', '#ffbb78', '#1f77b4', '#aec7e8', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
        }
      } // clear

      if (this.xAxisType === 'year') {
        this.graphOptions.axis.x = { type: 'timeseries', tick: { format: '%Y年'} }
      } else if (this.xAxisType === 'month') {
        this.graphOptions.axis.x = { type: 'timeseries', tick: { format: '%m月'} }
      } else {
        this.graphOptions.axis.x = { type: 'timeseries', tick: { format: '%d日'} }
      }

      let dateData = ['x']
      let sumKwhData = ['累積発電量実績']
      let sumKwhEstimateData = ['累積発電量予測']
      let kwhData = ['発電量実績']
      let kwhEstimateData = ['発電量予測']
      
      console.log(this.records)

      for (const record of this.records) {
        if (this.xAxisType === 'year') {
          dateData.push(record.year)
        } else if (this.xAxisType === 'month') {
          dateData.push(record.yearMonth)
        } else {
          dateData.push(record.date)
        }
        sumKwhData.push(record.sumKwh)
        sumKwhEstimateData.push(record.sumKwhEstimate)
        kwhData.push(record.kwh)
        kwhEstimateData.push(record.kwhEstimate)
      }
      this.graphOptions.data.columns.push(dateData)
      this.graphOptions.data.columns.push(sumKwhEstimateData)
      this.graphOptions.data.columns.push(kwhEstimateData)
      this.graphOptions.data.columns.push(sumKwhData)
      this.graphOptions.data.columns.push(kwhData)
    }
  }
}
</script>
