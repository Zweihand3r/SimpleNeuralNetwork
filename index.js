import { initCanvas, drawNetwork, drawTruthTable, mousemove, mousedown, mouseup } from "./src/canvas.js"
import { initControls, updateDropdowns, updateSliders } from "./src/controls.js"
import { Network, activationFunctions } from "./src/network.js"
import presets from "./src/presets.js"

const canvas = document.body.querySelector('#canvas')
canvas.setAttribute('width', window.innerWidth)
canvas.setAttribute('height', window.innerHeight)

const ctx = canvas.getContext('2d')
initCanvas(ctx)
canvas.addEventListener('mousedown', mousedown)
canvas.addEventListener('mousemove', mousemove)
canvas.addEventListener('mouseup', mouseup)
canvas.addEventListener('mouseout', mouseup)

const network = new Network(2, 3, 1)
network.setActivationFunction(activationFunctions.relu)
network.outputLayer.setActivationFunction(activationFunctions.sigmoid)
const [l1, l2, l3] = network.layers

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

const preset = presets.xor3rs

network.setInputs([1, 0])
network.loadWeightsAndBiases(preset)
updateNetowrk()

initControls(network.layers, updateNetowrk)
updateSliders({ inputs: [1, 0], layers: preset })
updateDropdowns(['relu', 'sigmoid'])

window.compute = function() {
  return network.compute(arguments)
}

window.setInputs = function() {
  network.setInputs(arguments)
  updateNetowrk()
  return 0
}

window.printNetwork = function(name = '') {
  return JSON.stringify(network.print()).replace(/\"/g, '')
}

console.log(l1.neurons, l2.neurons, l3.neurons)