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
    int m_inputCount;
    int m_outputCount;
    int m_nodeCount;

    QVector<QVector<float>> syn0;
    QVector<QVector<float>> syn1;

    QVector<QVector<float>> train(QVector<QVector<float>> inputs, QVector<QVector<float>> outputs, const int trainSteps);

    QVector<QVector<float>> sigmoid(QVector<QVector<float>> mat);
    QVector<QVector<float>> sigmoidDerivative(QVector<QVector<float>> mat);
    QVector<QVector<float>> randomisedWeights(const int rows, const int cols);

    QVector<QVector<float>> toVector(const QStringList stringList);
    QStringList toStringList(const QVector<QVector<float>> vector);

signals:

public slots:
    void initializeNetwork(const int inputCount, const int outputCount, const int nodeCount = 4);
    void resetNetwork();

    QStringList train(QStringList inputs, QStringList outputs, const int trainSteps = 1);
    QStringList compute(QStringList inputs);

    /* ---^--- */
    QVector<QVector<float>> getSigmoid(QVector<QVector<float>> mat);
    QVector<QVector<float>> getSigmoidDerivative(QVector<QVector<float>> mat);
    QVector<QVector<float>> getRandomisedWeights(const int rows, const int cols);
};

#endif // NEURAL_H
