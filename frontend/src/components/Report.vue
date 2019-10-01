<template>
  <div class="md-elevation-1 report" v-bind:class="{ blocked: report.blocked }">
    <div>
      <div>
        <p>
          <label>Id:</label> 
          {{ report.id }}
        </p>
        <p>
          <label>State:</label> 
          {{ report.state }}
        </p>
      </div>
      <div>
        <p>
          <label>Type:</label> 
          {{ report.payload.reportType }}
        </p>
        <p>
          <label>Message:</label> 
          {{ report.payload.message }}
        </p>
      </div>
      <div class="buttons">
        <md-button 
          class="md-raised md-accent" 
          v-if="report.blocked !== true"
          @click="$store.commit('block', report.id)"
        >
          Block
        </md-button>
        <md-button @click="$store.commit('resolve', report.id)">
          Resolve
        </md-button>
      </div>
    </div>
    <md-button class="md-primary">
      Details
    </md-button>
  </div>
</template>

<script>
export default {
  name: "Report",
  props: {
    report: Object
  }
}
</script>

<style scoped lang="scss">
  .report {
    padding: 8px 17px;
    margin: 0 auto;
    margin-bottom: 24px;
    max-width: 480px;
    background: #fff;
    border: 3px solid transparent;
    transition: border .4s;
    .md-button {
      margin: 0;
      margin-top: 3px;
    }
    > div {
      display: grid;
      grid-template-columns: auto auto max-content;
      grid-gap: 11px;
      border-bottom: 1px solid #ccc;
      padding-bottom: 8px;
      label {
        color: #ccc;
        font-size: 13px;
        display: block;
        font-weight: bold;
      }
      p {
        color: #535353;
        margin-bottom: 8px;
      }
      .buttons {
        .md-button {
          display: block;
          margin: 8px 0;
        }
      }
    }
  }
  .report.blocked {
    border-color: #ff5252;
  }
</style>