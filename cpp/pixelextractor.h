#ifndef PIXELEXTRACTOR_H
#define PIXELEXTRACTOR_H

#include <QObject>
#include <QImage>
#include <QDebug>

class PixelExtractor : public QObject
{
    Q_OBJECT
public:
    explicit PixelExtractor(QObject *parent = nullptr);

signals:

public slots:
    /* get brightness(0-1) of image pixels */
    QList<qreal> getPixelBrightnessFromImage(const QString path);
};

#endif // PIXELEXTRACTOR_H
