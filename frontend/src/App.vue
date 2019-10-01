<template>
  <div id="app">
    <Report v-for="report in $store.state.reports" v-bind:key="report.id" :report="report" />
  </div>
</template>

<script>
import Report from "./components/Report.vue";

export default {
  name: "app",
  components: {
    Report
  },
  data: function () {
    return {
    }
  },
  mounted () {
    this.$store.dispatch('listReports')
  }
}
</script>

<style lang="scss">
  #app{
    padding: 24px;
  }
</style>
