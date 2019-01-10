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
    QVector<QVector<float>> randomisedWeights(const int rows, const int cols);

signals:

public slots:
    QVector<QVector<float>> getSigmoid(QVector<QVector<float>> mat);
    QVector<QVector<float>> getSigmoidDerivative(QVector<QVector<float>> mat);
    QVector<QVector<float>> getRandomisedWeights(const int rows, const int cols);
};

#endif // NEURAL_H
