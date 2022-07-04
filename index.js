import { initCanvas, drawNetwork, drawTruthTable, mousemove, mousedown, mouseup } from "./src/canvas.js"
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

let network

const initNetwork = presetKey => {
  if (!presetKey) {
    network = new Network(2, 2, 1)
    network.setActivationFunction(activationFunctions.relu)
    network.outputLayer.setActivationFunction(activationFunctions.sigmoid)
  
    initControls(network.layers, updateNetowrk, presetSelected)
  } else {
    const preset = presets[presetKey]
    const { layers, activations } = parsePreset(presetKey)

    network = new Network(layers)
    initControls(network.layers, updateNetowrk, presetSelected, { selectedPreset: presetKey })

    network.loadWeightsAndBiases(preset)
    updateSliders({ layers: preset })

    for (let i = 1; i < network.layers.length; i++) {
      network.layers[i].setActivationFunction(activationFunctions[activations[i - 1]])
    }
    updateDropdowns(activations)
  }
  
  updateNetowrk()
}

const updateNetowrk = () => {
  network.forward()
  drawNetwork(network.layers)
  drawTruthTable([
    network.compute([0, 0])[0].toFixed(2),
    network.compute([0, 1])[0].toFixed(2),
    network.compute([1, 0])[0].toFixed(2),
    network.compute([1, 1])[0].toFixed(2)
  ])
}

const presetSelected = presetKey => {
  if (presetKey !== 'NONE') {
    initNetwork(presetKey)
  }
}

initNetwork()


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
