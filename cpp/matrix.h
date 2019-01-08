#ifndef MATRIX_H
#define MATRIX_H

#include <QVector>
#include <QDebug>


class Matrix
{
public:
    Matrix();

    static QVector<QVector<float>> dot(QVector<QVector<float>> mat_a, QVector<QVector<float>> mat_b);
    static QVector<QVector<float>> add(QVector<QVector<float>> mat_a, QVector<QVector<float>> mat_b);
    static QVector<QVector<float>> subtract(QVector<QVector<float>> mat_a, QVector<QVector<float>> mat_b);
    static QVector<QVector<float>> multiply(QVector<QVector<float>> mat_a, QVector<QVector<float>> mat_b);
    static QVector<QVector<float>> transpose(QVector<QVector<float>> mat);
};

#endif // MATRIX_H
