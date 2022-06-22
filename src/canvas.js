import { drawCircle, drawLine, drawText } from "./util.js"

export const initCanvas = ctx => {
  ctx.translate(100, 100)
}

export const drawNetwork = (ctx, layers) => {
  ctx.clearRect(-100, -100, ctx.canvas.width - 100, ctx.canvas.height - 100)

  layers.forEach((layer, xi) => {
    layer.neurons.forEach((neuron, yi) => {
      let offset = 0
      if (xi === 0) offset = 74
      else if (xi === 2) offset = 150
      neuron.x = xi * 300
      neuron.y = yi * 150 + offset
    })
  })
  
  layers.forEach(layer => {
    layer.neurons.forEach(neuron => {
      drawCircle(ctx, neuron.x, neuron.y, 35, '#fff')
      neuron.outputNeurons.forEach((outputNeuron, i) => {
        const x1 = neuron.x, y1 = neuron.y, x2 = outputNeuron.x, y2 = outputNeuron.y
        drawLine(ctx, x1, y1, x2, y2, ['#fff'])
        
        const angle = calculateAngle(x1, y1, x2, y2)
        const text = neuron.weights[i].toFixed(5)
        ctx.save()
        ctx.translate(x1, y1)
        ctx.rotate(angle)
        const { x, y, width } = drawText(ctx, 45, 1, text, { horzCentered: false, measureOnly: true })
        ctx.fillStyle = '#000000'
        ctx.fillRect(x, y - 12, width, 14)
        drawText(ctx, 45, 1, text, { horzCentered: false, color: '#66aaff' })
        ctx.restore()
      })
      drawText(ctx, neuron.x, neuron.y, neuron.activation.toFixed(5), { color: '#000' })
      drawText(ctx, neuron.x, neuron.y + 50, neuron.bias, { color: '#aa66ff' })
    })
  })
}

const calculateAngle = (x1, y1, x2, y2) => {
  const dx = x2 - x1
  const dy = y2 - y1
  return Math.atan(dy / dx)
}