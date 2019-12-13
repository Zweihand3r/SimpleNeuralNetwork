#include "pixelextractor.h"

PixelExtractor::PixelExtractor(QObject *parent) : QObject(parent)
{

}

QList<qreal> PixelExtractor::getPixelBrightnessFromImage(const QString path)
{
    QList<qreal> pixelData = {};

    QImage *image = new QImage();
    image->load(path);

    for (int i = 0; i < image->width(); i++) {
        for (int j = 0; j < image->height(); j++) {
            QColor pixelColor = image->pixelColor(j, i);
            pixelData << pixelColor.red() / 255.0;
        }
    }

    return pixelData;
}
