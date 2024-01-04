import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['input']
  connect() {
  }
  searchProcess() {
    const booksSection = document.querySelector('#books')
    booksSection.classList.add('hidden');
    clearTimeout(this.timeout)
    this.timeout =  setTimeout(() => {
      const input = this.inputTarget.value;
      const url = this.element.dataset.requestUrl
      const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");
      const options = {
        method: "POST",
        headers: {
          'Content-Type': "application/json",
          'X-CSRF-Token': csrf
        },
        body: JSON.stringify({ search: input })
      }

      fetch(url, options).then(res =>res.text())
      .then(res => {
        booksSection.classList.remove('hidden')
        document.body.insertAdjacentHTML('beforeend', res)
      })
    }, 1500) 
  }
}
