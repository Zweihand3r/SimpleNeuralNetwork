import { activationFunctions } from "./network.js"

const ACTIVATION_OPTIONS = ['relu', 'sigmoid']
const PRESET_OPTIONS = ['NONE', 'xor_221_rs', 'xor_231_rs']

let ctrlRoot
let sliders = [], inputSliders = []
let dropdowns = []

export const initControls = (layers, triggerRedraw, presetSelected, params) => {
  const { selectedPreset = '' } = params || { selectedPreset: '' }

  if (ctrlRoot) {
    sliders = []
    inputSliders = []
    dropdowns = []
    ctrlRoot.innerHTML = ''
  }

  ctrlRoot = createDiv(document.body, { className: 'ctrl-root' })
  createOptions(ctrlRoot, layers, triggerRedraw, presetSelected, { selectedPreset })

  for (let li = 1; li < layers.length; li++) {
    const layer = layers[li]
    const layerCon = createDiv(ctrlRoot, { className: 'layer-con' })
    const slLayer = []

    const titleRow = createDiv(layerCon, { 
      className: 'layer-title',
      text: (li === layers.length - 1 ? 'OUTPUT LAYER' : `LAYER ${li}`)
    })

    createDiv(titleRow, { text: `Activation Function -${spaces(2)}` })
    dropdowns.push(
      createDropdown(titleRow, ACTIVATION_OPTIONS, v => {
        layer.setActivationFunction(activationFunctions[v])
        triggerRedraw()
      })
    )

    for (let ni = 0; ni < layer.neurons.length; ni++) {
      const neuron = layer.neurons[ni]
      const neuronCon = createDiv(layerCon, { className: 'neuron-con' })
      const slNeuron = { w: [] }

      for (let wi = 0; wi < neuron.weights.length; wi++) {
        slNeuron.w.push(
          createSlider(neuronCon, v => {
            neuron.weights[wi] = parseFloat(v)
            triggerRedraw()
          })
        )
      }

      slNeuron.b = createSlider(neuronCon, v => {
        neuron.bias = parseFloat(v)
        triggerRedraw()
      }, { color: 'green', range: [-5, 5] })

      slLayer.push(slNeuron)
    }

    sliders.push(slLayer)
  }
}

export const updateSliders = ({ inputs, layers }) => {
  if (inputs) {
    for (let i = 0; i < inputs.length; i++) {
      inputSliders[i].value = inputs[i]
    }
  }
  if (layers) {
    for (let li = 0; li < sliders.length; li++) {
      for (let ni = 0; ni < sliders[li].length; ni++) {
        for (let wi = 0; wi < sliders[li][ni].w.length; wi++) {
          sliders[li][ni].w[wi].value = layers[li + 1][ni].w[wi]
        }
        sliders[li][ni].b.value = layers[li + 1][ni].b
      }
    }
  }
}

export const updateDropdowns = afNames => {
  for (let i = 0; i < dropdowns.length; i++) {
    dropdowns[i].value = afNames[i]
  }
}

const createOptions = (parent, layers, triggerRedraw, presetSelected, params) => {
  const { selectedPreset = '' } = params || { selectedPreset: '' }

  let _inputSliders = []
  const inputLayerCon = createDiv(parent, { className: 'layer-con input-layer-con' })
  createDiv(inputLayerCon, { className: 'layer-title', text: 'OPTIONS' })

  const inputNeuronsCon = createDiv(inputLayerCon, { className: 'neuron-con' })
  createDiv(inputNeuronsCon, { className: 'ctrl-lbl', text: 'Inputs' })

  const inputLayer = layers[0]
  for (let ini = 0; ini < inputLayer.neurons.length; ini++) {
    _inputSliders.push(
      createSlider(inputNeuronsCon, v => {
        inputLayer.neurons[ini].activation = v
        triggerRedraw()
      }, { color: 'white', range: [0, 1], step: .01 })
    )
  }

  createVertSpacing(inputNeuronsCon, 12)
  createDiv(inputNeuronsCon, { className: 'ctrl-lbl', text: 'Network Presets' })
  createDropdown(inputLayerCon, PRESET_OPTIONS, v => {
    presetSelected(v)
  }, { value: selectedPreset, className: 'ctrl-item' })
  createVertSpacing(inputLayerCon, 12)

  inputSliders = _inputSliders
}

const createDiv = (parent, params) => {
  const { id, className, text } = params || {}
  if (parent) {
    const div = document.createElement('div')
    if (id) div.id = id
    if (className) div.className = className
    if (text) div.innerHTML = text
    parent.appendChild(div)
    return div
  } else {
    throw (`parent needs to be specified`)
  }
}

const createSlider = (parent, onChange, params) => {
  const { 
    color = '', range = [-2, 2], step = .00001 
  } = params || { 
    color: '', range: [-5, 5], step: .00001 
  }
  if (parent) {
    const slider = document.createElement('input')
    slider.type = 'range'
    slider.className = `slider slider-${color}`
    slider.value = 0
    slider.min = range[0]
    slider.max = range[1]
    slider.step = step
    slider.addEventListener('input', e => onChange(e.target.value))
    parent.appendChild(slider)
    return slider
  } else {
    throw (`parent needs to be specified`)
  }
}

const createDropdown = (parent, list, onChange, params) => {
  const { value, className } = params || {}
  if (parent) {
    const select = document.createElement('select')
    select.className = className || ''
    list.forEach(item => {
      const option = document.createElement('option')
      option.value = item
      option.innerHTML = item
      select.appendChild(option)
    })
    if (value) {
      select.value = value
    }
    select.addEventListener('change', e => onChange(e.target.value))
    parent.appendChild(select)
    return select
  } else {
    throw (`parent needs to be specified`)
  }
}

const createVertSpacing = (parent, spacing) => {
  if (parent) {
    const div = createDiv(parent)
    div.style.height = `${spacing}px`
  }
}

const spaces = (count) => Array(count).fill('&nbsp').join('')
