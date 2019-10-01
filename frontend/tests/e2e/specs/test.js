describe("List", () => {
  it("List reports", () => {
    cy.visit('http://localhost:8080')
    cy.get("#app")
  })
})

describe("Mark as spam", () => {
  it("Mark a reports as spam", () => {
    cy.visit('http://localhost:8080')
    cy.get('.report').first().get('.buttons > button').first().click()
    cy.wait(1000)
    cy.get('.report').first().should('have.class', 'blocked')
  })
})

describe("Resolve", () => {
  it("Resolve all reports", () => {
    cy.visit('http://localhost:8080')
    cy.get('#app').children().each(function(){
      cy.get('.buttons > button').last().click()
    })
    cy.get('#app').children().should('have.length', 0)
  })
})
