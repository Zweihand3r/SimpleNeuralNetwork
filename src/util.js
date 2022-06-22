window._id = 0
export const generateId = () => window._id++

export const drawCircle = (ctx, x, y, radius, color) => {
  ctx.fillStyle = color
  ctx.beginPath()
  ctx.arc(x, y, radius, 0, 2 * Math.PI)
  ctx.closePath()
  ctx.fill()
}

export const drawLine = (ctx, x1, y1, x2, y2, colors, optionals) => {
  const { 
    dashed = false,
    lineWidth = 1 
  } = optionals || { 
    dashed: false,
    lineWidth: 1
  }
  if (colors.length > 1) {
    const grad = ctx.createLinearGradient(x1, y1, x2, y2)
    grad.addColorStop(0, colors[0])
    grad.addColorStop(1, colors[1])
    ctx.strokeStyle = grad
  } else {
    ctx.strokeStyle = colors[0]
  }
  if (dashed) {
    ctx.setLineDash([10, 5])
  }
  ctx.beginPath()
  ctx.lineWidth = lineWidth
  ctx.moveTo(x1, y1)
  ctx.lineTo(x2, y2)
  ctx.closePath()
  ctx.stroke()
  if (dashed) {
    ctx.setLineDash([])
  }
}

export const drawText = (ctx, x, y, text, optionals) => {
  const {
    size = 15,
    color = '#fff',
    horzCentered = true,
    vertCentered = true,
    measureOnly = false
  } = optionals || {
    size: 15,
    color: '#fff',
    horzCentered: true,
    vertCentered: true,
    measureOnly: false
  }
  ctx.font = `${size}px verdana`
  ctx.fillStyle = color
  const { width } = ctx.measureText(text)
  x -= horzCentered ? (width / 2) : 0
  y += vertCentered ? (size / 4) : 0
  if (!measureOnly) {
    ctx.fillText(text, x, y)
  }
  return { x, y, width }
}