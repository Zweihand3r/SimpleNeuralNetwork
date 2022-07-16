import { drawCircle, drawLine, drawText } from "./util.js"

const TRUTH_TABLE_INPUT = ['0    0', '0    1', '1    0', '1    1']

let ctx, savedLayers, savedTruthValues
let tx = 100, ty = 100, maxNeurons = 0
let truthTableEnabled

export const initCanvas = _ctx => {
  ctx = _ctx
  ctx.translate(tx, ty)
}

export const drawNetwork = (layers) => {
  savedLayers = layers
  ctx.clearRect(-100, -100, ctx.canvas.width, ctx.canvas.height)

  maxNeurons = 0
  layers.forEach(layer => {
    maxNeurons = Math.max(maxNeurons, layer.neurons.length)
  })

  layers.forEach((layer, xi) => {
    layer.neurons.forEach((neuron, yi) => {
      neuron.x = xi * 300
      neuron.y = yi * 150 + (maxNeurons * 150 - layer.neurons.length * 150) / 2
    })
  })
  
  layers.forEach(layer => {
    layer.neurons.forEach(neuron => {
      drawCircle(ctx, neuron.x, neuron.y, 35, '#fff')
      neuron.inputNeurons.forEach((inputNeuron, i) => {
        const x1 = inputNeuron.x, y1 = inputNeuron.y, x2 = neuron.x, y2 = neuron.y
        drawLine(ctx, x1, y1, x2, y2, ['#fff'])
        
        const angle = calculateAngle(x1, y1, x2, y2)
        const text = neuron.weights[i].toFixed(5)
        ctx.save()
        ctx.translate(x2, y2)
        ctx.rotate(angle)
        // const { x, y, width } = drawText(ctx, 45, 1, text, { horzCentered: false, measureOnly: true })
        const { x, y, width } = drawText(ctx, -120, 1, text, { horzCentered: false, measureOnly: true })
        ctx.fillStyle = '#000000'
        ctx.fillRect(x, y - 12, width, 14)
        drawText(ctx, -120, 1, text, { horzCentered: false, color: '#66aaff' })
        ctx.restore()
      })
    })
  })
  
  layers.forEach((layer, i) => {
    if (i > 0) {
      layer.neurons.forEach(neuron => {
        drawText(ctx, neuron.x, neuron.y, neuron.activation.toFixed(5), { color: '#000' })
        drawText(ctx, neuron.x, neuron.y + 50, neuron.bias.toFixed(5), { color: '#aa66ff' })
      })
    } else {
      layer.neurons.forEach(neuron => {
        drawText(ctx, neuron.x, neuron.y, neuron.activation, { color: '#000' })
      })
    }
  })
}

export const enableTruthTable = v => {
  truthTableEnabled = v
}

export const drawTruthTable = (values = [0, 0, 0, 0]) => {
  if (truthTableEnabled) {
    savedTruthValues = values
    ctx.save()
    ctx.translate(720, (maxNeurons * 150 - 285) / 2)
    for (let i = 0; i < TRUTH_TABLE_INPUT.length; i++) {
      drawText(ctx, 0, i * 50, TRUTH_TABLE_INPUT[i])
      ctx.beginPath()
      ctx.rect(50, i * 50 - 4, 200, 6)
      ctx.closePath()
      ctx.stroke()
      ctx.fillRect(50, i * 50 - 4, Math.min(values[i] * 200, 200), 6)
      drawText(ctx, 300, i * 50, values[i])
    }
    ctx.restore()
  }
}

const calculateAngle = (x1, y1, x2, y2) => {
  const dx = x2 - x1
  const dy = y2 - y1
  return Math.atan(dy / dx)
}


/* Pan code */

let mx, my, isMouseDown = false

export const mousedown = e => {
  mx = e.clientX
  my = e.clientY
  isMouseDown = true
}

export const mousemove = e => {
  if (isMouseDown) {
    tx = e.clientX - mx
    ty = e.clientY - my
    mx = e.clientX
    my = e.clientY
    ctx.translate(tx, ty)
    drawNetwork(savedLayers)
    drawTruthTable(savedTruthValues)
  }
}

export const mouseup = e => {
  isMouseDown = false
}
