<template>
  <div>
    <h1>API Tester</h1>
    URL: <input type="text" style="width: 400px" v-model="url">
    <br/>
    <br/>
    Token: <input type="text" v-model="token">
    <br/>
    <br/>
    Parameters:
    <table class="ui table" style="width: 400px">
      <colgroup>
        <col width="40%"/>
        <col width="40%"/>
        <col width="20%"/>
      </colgroup>
      <thead>
        <tr>
          <th>key</th>
          <th>value</th>
          <th>
            <a href="javascript:void(0)" @click="addParam">Add</a>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="param in params">
          <td>
            <input v-model="param.key">
          </td>
          <td>
            <input v-model="param.value" >
          </td>
          <td>
            <a href="javascript:void(0)" @click="removeParam(param)">Remove</a>
          </td>
        </tr>
      </tbody>
    </table>
    <br/>
    <button type="button" @click="sendRequest">Send</button>
    <br/>
    <br/>
    Result:
    <br/>
    <b>  Status {{ result_status }}</b>
    <br/>
    <b>  Body</b>
    <br/>
    <textarea readonly="readonly" rows="30" cols="60" v-model="result"></textarea>
  </div>
</template>

<script>
export default {
  props: {
  },
  data() {
    return {
      params: [],
      url: '',
      token: '',
      result: '',
      result_status: ''
    }
  },
  mounted() {
  },
  methods: {
    sendRequest() {
      let headers = {}
      if (this.token && this.token.length > 0) {
        headers['Authorization'] = `Token ${this.token}`
      }
      let data = {}
      for (const param of this.params) {
        if (param.key && param.key.length > 0) {
          data[param.key] = param.value
        }
      }
      $.ajax({
        url: this.url,
        type: 'GET',
        headers: headers,
        data: data,
      }).done((data, textStatus) => {
        this.result = JSON.stringify(data, null, '  ')
        this.result_status = 200
      }).fail((jqXHR, textStatus) => {
        this.result = '[ERROR]'
        this.result_status = jqXHR.statusCode().status
      });
    },
    addParam() {
      this.params.push({key: '', value: ''})
    },
    removeParam(param) {
      this.params.splice(this.params.indexOf(param), 1)
    }
  }
}
</script>
