import Vue from "vue"
import Vuex from "vuex"
import VueResource from "vue-resource"

Vue.use(Vuex)
Vue.use(VueResource)

export default new Vuex.Store({
	state: {
		reports: []
	},  
	actions: {
		listReports() {
			Vue.http.get('/reports')
			.then(response => {
            	this.commit("addReports", response.body)
			}, response => {
				console.log(response)
			})
		}
	},
	mutations: {
		addReports(state, reports) {
		    state.reports = reports
		},
		block(state, id) {
			Vue.http.put('/reports/' + id, {
				blocked: true
			})
			.then(response => {
            	this.commit("addReports", response.body)
			}, response => {
				console.log(response)
			})
		},
		resolve(state, id) {
			Vue.http.put('/reports/' + id, {
				ticketState: "CLOSED"
			})
			.then(response => {
            	this.commit("addReports", response.body)
			}, response => {
				console.log(response)
			})
		}		
	}
})