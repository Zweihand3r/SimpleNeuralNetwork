import { initCanvas, drawNetwork, drawTruthTable } from "./src/canvas.js"
import { initControls } from "./src/controls.js"
import { activationFunctions, Network } from "./src/network.js"

const canvas = document.body.querySelector('#canvas')
canvas.setAttribute('width', window.innerWidth)
canvas.setAttribute('height', window.innerHeight)

const ctx = canvas.getContext('2d')
initCanvas(ctx)

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

network.setInputs([1, 0])
updateNetowrk()

initControls(network.layers, updateNetowrk)

window.compute = function() {
  return network.compute(arguments)
}

window.setInputs = function() {
  network.setInputs(arguments)
  updateNetowrk()
  return 0
}

console.log(l1.neurons, l2.neurons, l3.neurons)