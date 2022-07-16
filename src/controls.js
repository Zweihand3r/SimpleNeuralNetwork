import { newNetworkModal, selectionListModal } from "./modals.js"
import { activationFunctions } from "./network.js"
import { 
  createButton, createDiv, createDropdown, createHorzSpacing, createSlider, createVertSpacing, spaces 
} from "./ui-comps.js"

const ACTIVATION_OPTIONS = ['relu', 'sigmoid']
const PRESET_OPTIONS = ['xor_221_rs', 'xor_231_rs']

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
  } else {
    ctrlRoot = createDiv(document.body, { className: 'ctrl-root' })
  }

  initOptions(ctrlRoot, layers, triggerRedraw, presetSelected, { selectedPreset })

  for (let li = 1; li < layers.length; li++) {
    const layer = layers[li]
    const layerCon = createDiv(ctrlRoot, { className: 'layer-con' })
    const slLayer = []

    const titleRow = createDiv(layerCon, { 
      className: 'layer-title',
      text: (li === layers.length - 1 ? 'OUTPUT LAYER' : `LAYER ${li}`)
    })

    createDiv(titleRow, { text: `${spaces(2)}|${spaces(2)}Activation Function -${spaces(2)}` })
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

const initOptions = (parent, layers, triggerRedraw, presetSelected, params) => {
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
  createDiv(inputNeuronsCon, { className: 'ctrl-lbl', text: 'Network' })
  createVertSpacing(inputNeuronsCon, 6)

  const row = createDiv(inputNeuronsCon, { className: 'row' })
  createButton(row, 'New', () => {
    newNetworkModal(layers => presetSelected({ layers }))
  })

  createHorzSpacing(row, 12)

  createButton(row, 'Load', () => {
    selectionListModal(PRESET_OPTIONS, presetKey => presetSelected({ presetKey }))
  })

  inputSliders = _inputSliders
}
