import { initCanvas, drawNetwork, drawTruthTable, mousemove, mousedown, mouseup, enableTruthTable } from "./src/canvas.js"
import { initControls, updateDropdowns, updateSliders } from "./src/controls.js"
import { Network, activationFunctions } from "./src/network.js"
import presets, { parsePreset } from "./src/presets.js"

const canvas = document.body.querySelector('#canvas')
canvas.setAttribute('width', window.innerWidth)
canvas.setAttribute('height', window.innerHeight)

const ctx = canvas.getContext('2d')
initCanvas(ctx)
canvas.addEventListener('mousedown', mousedown)
canvas.addEventListener('mousemove', mousemove)
canvas.addEventListener('mouseup', mouseup)
canvas.addEventListener('mouseout', mouseup)

let network, truthTableEnabled

const initNetwork = ({ presetKey, layers }) => {
  if (layers) {
    network = new Network(...layers)
    network.setActivationFunction(activationFunctions.relu)
    network.outputLayer.setActivationFunction(activationFunctions.sigmoid)
  
    initControls(network.layers, updateNetowrk, presetSelected)
    updateTruthTableFeasibility(layers)
  } else if (presetKey) {
    const preset = presets[presetKey]
    const { layers, activations } = parsePreset(presetKey)

    network = new Network(...layers)
    initControls(network.layers, updateNetowrk, presetSelected, { selectedPreset: presetKey })

    network.loadWeightsAndBiases(preset)
    updateSliders({ layers: preset })

    for (let i = 1; i < network.layers.length; i++) {
      network.layers[i].setActivationFunction(activationFunctions[activations[i - 1]])
    }
    updateDropdowns(activations)
  } else {
    throw('Please provide a presetKey or layers to initialise the network')
  }
  
  updateNetowrk()
}

const updateNetowrk = () => {
  network.forward()
  drawNetwork(network.layers)
  if (truthTableEnabled) {
    drawTruthTable([
      network.compute([0, 0])[0].toFixed(2),
      network.compute([0, 1])[0].toFixed(2),
      network.compute([1, 0])[0].toFixed(2),
      network.compute([1, 1])[0].toFixed(2)
    ])
  }
}

const presetSelected = ({ presetKey, layers }) => {
  initNetwork({ presetKey, layers })
}

const updateTruthTableFeasibility = layers => {
  truthTableEnabled = layers[0] === 2 && layers[layers.length - 1] === 1
  enableTruthTable(truthTableEnabled)
}

initNetwork({ layers: [2, 2, 1] })


/* Console functions */

window.compute = function() {
  return network.compute(arguments)
}

window.setInputs = function() {
  network.setInputs(arguments)
  updateNetowrk()
  return 0
}

window.printNetwork = function() {
  return JSON.stringify(network.print()).replace(/\"/g, '')
}
