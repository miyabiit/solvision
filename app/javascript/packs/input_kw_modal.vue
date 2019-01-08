<template>
  <div ref="modal_root" class="ui mini modal">
    <div class="header">発電量実績</div>
    <div class="content">
      <form class="ui form">
        <div class="field">
          <div class="ui right labeled input">
            <input type="text" style="text-align: right;" placeholder="" v-model="inputKWh" :disabled="!inputKWhEnabled">
            <div class="ui basic label">kWh</div>
          </div>
        </div>
        <div class="field">
          <input type="checkbox" v-model="inputKWhEnabled"> 実績値を直接入力
        </div>
        <div class="ui segment">
          <h4 class="ui horizontal divider header">
            Solarsから取得した実績値
          </h4>
          <div class="field" v-if="solarKWh">
            {{ solarMixedKWh }} kWh
            <span v-if="estimateRemainsKWh > 0">
              (含予測値: {{ estimateRemainsKWhRounded }} kWh)
            </span>
          </div>
          <div class="field" v-if="!solarKWh">
            実績値がありません
            (予測値: {{ estimateRemainsKWhRounded }} kWh)
          </div>
        </div>
        <div class="field">
          <button type="button" class="ui button" @click="hide">キャンセル</button>
          <button type="button" class="ui primary button" @click="save">更新</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  mounted() {
    vbus.$on('show-input-kw-modal', (month, mixedKWh, solarKWh, estimateRemainsKWh, inputKWh, inputKWhEnabled) => {this.show(month, mixedKWh, solarKWh, estimateRemainsKWh, inputKWh, inputKWhEnabled)})
  },
  props: {
    year: Number,
    facilityId: Number,
  },
  data() {
    return {
      month: null,
      mixedKWh: null,
      solarKWh: null,
      estimateRemainsKWh: null,
      inputKWh: null,
      inputKWhEnabled: false,
    }
  },
  watch: {
    inputKWhEnabled(v) {
      if (v) {
      } else {
        this.inputKWh = this.solarMixedKWh
      }
    }
  },
  computed: {
    solarMixedKWh() {
      return Math.round((this.solarKWh || 0) + (this.estimateRemainsKWh || 0))
    },
    solarKWhRounded() {
      return Math.round(this.solarKWh)
    },
    estimateRemainsKWhRounded() {
      return Math.round(this.estimateRemainsKWh)
    }
  },
  methods: {
    show(month, mixedKWh, solarKWh, estimateRemainsKWh, inputKWh, inputKWhEnabled) {
      this.month = month
      this.mixedKWh = mixedKWh
      this.inputKWh = Math.round(mixedKWh)
      this.solarKWh = solarKWh
      this.estimateRemainsKWh = estimateRemainsKWh
      this.inputKWhEnabled = inputKWhEnabled

      $(this.$refs.modal_root).modal('show')
    },
    hide() {
      $(this.$refs.modal_root).modal('hide')
    },
    save() {
      vbus.$emit('show-spinner')
      $.ajax({
        method: "POST",
        url: `/monthly_solars/${this.year}/${this.month}/facilities/${this.facilityId}.json`,
        data: {
          monthly_solar: {
            input_kwh: this.inputKWh,
            input_kwh_enabled: (this.inputKWhEnabled ? 1 : 0)
          }
        }
      }).done(( data ) => {
        vbus.$emit('show-message-bar', '更新しました')
      })     
      .fail(( data ) => {
        vbus.$emit('show-message-bar', 'エラーが発生しました')
      })
      .always(( data ) => {
        vbus.$emit('hide-spinner')
        this.hide()
        location.reload()
      })
    }
  }
}
</script>
