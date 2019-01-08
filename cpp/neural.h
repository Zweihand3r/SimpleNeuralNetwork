#ifndef NEURAL_H
#define NEURAL_H

#include <QObject>
#include <QVector>
#include <QtMath>

#include "cpp/matrix.h"

class Neural : public QObject
{
    Q_OBJECT
public:
    explicit Neural(QObject *parent = nullptr);

private:
    QVector<QVector<float>> sigmoid(QVector<QVector<float>> mat);
    QVector<QVector<float>> sigmoidDerivative(QVector<QVector<float>> mat);

signals:

public slots:
};

#endif // NEURAL_H
