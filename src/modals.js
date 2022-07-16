import { createButton, createDiv, createStepper } from "./ui-comps.js"

let modal, content
let _selectionListModal, _newNetworkModal
let newNetworkDelegate

const init = () => {
  modal = document.createElement('div')
  modal.className = 'modal-root'
  modal.addEventListener('click', () => {
    closeModal()
  })

  _selectionListModal = document.createElement('div')
  _selectionListModal.className = 'modal-cont'
  _selectionListModal.addEventListener('click', e => {
    e.stopPropagation()
  })

  _newNetworkModal = document.createElement('div')
  _newNetworkModal.className = 'modal-cont'
  _newNetworkModal.addEventListener('click', e => {
    e.stopPropagation()
  })
  createDiv(_newNetworkModal, { className: 'modal-title', text: 'Specify neurons<br/>in each Layer' })
  const nnmContent = createDiv(_newNetworkModal, { className: 'nnm-content' })
  const nnmSteppers = createDiv(nnmContent, { className: 'nnm-steppers' })
  const steppers = []
  for (let i = 0; i < 3; i++) {
    steppers.push(createStepper(nnmSteppers))
  }

  newNetworkDelegate = {
    set layers(v) {
      steppers.forEach((stepper, i) => {
        stepper.value = v[i]
      })
    },
    get layers() {
      return steppers.map(stepper => stepper.value)
    },
    footer: createDiv(nnmContent)
  }
}

export const selectionListModal = (list, onSelect) => {
  _selectionListModal.innerHTML = null

  createDiv(_selectionListModal, { className: 'modal-title', text: 'Load from' })
  list.forEach(text => {
    const item = createDiv(_selectionListModal, { className: 'slm-item', text })
    item.addEventListener('click', () => {
      onSelect(text)
      closeModal()
    })
  })

  content = _selectionListModal
  document.body.appendChild(modal)
  modal.appendChild(content)
}

export const newNetworkModal = (onCreate) => {
  newNetworkDelegate.footer.innerHTML = null
  createButton(newNetworkDelegate.footer, 'Create Netowrk', () => {
    onCreate(newNetworkDelegate.layers)
    closeModal()
  })

  content = _newNetworkModal
  document.body.appendChild(modal)
  modal.appendChild(content)
}

export const closeModal = () => {
  document.body.removeChild(modal)
  modal.removeChild(content)
  content = null
}

init()