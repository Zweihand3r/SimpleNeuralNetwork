#include "cpptests.h"

CppTests::CppTests(QObject *parent) : QObject(parent)
{

}

QVector<QVector<float> > CppTests::toVector(const QStringList stringList)
{
    QVector<QVector<float>> vector;
    for (QString rowStr : stringList) {
        QStringList rowElements = rowStr.split(" ");
        QVector<float> row;

        for (QString element : rowElements) {
            row.push_back(element.toFloat());
        }

        vector.push_back(row);
    }

    return vector;
}

QStringList CppTests::toStringList(const QVector<QVector<float> > vector)
{
    QStringList stringList;
    for (QVector<float> row : vector) {
        QString rowStr = "";

        for (int index = 0; index < row.length(); index++) {
            if (index > 0) rowStr += " ";
            rowStr += QString::number(row[index]);
        }

        stringList << rowStr;
    }

    return stringList;
}

QStringList CppTests::testDot(QStringList str_a, QStringList str_b)
{
    QVector<QVector<float>> mat_a = toVector(str_a);
    QVector<QVector<float>> mat_b = toVector(str_b);

    qDebug() << "cpptests.cpp: testDot > mat_a:" << mat_a;
    qDebug() << "cpptests.cpp: testDot > mat_b:" << mat_b;

    QVector<QVector<float>> res = Matrix::dot(mat_a, mat_b);

    QStringList resStr = toStringList(res);
    return resStr;
}

QStringList CppTests::testBasicOperation(QStringList str_a, QStringList str_b, int opIndex)
{
    QVector<QVector<float>> mat_a = toVector(str_a);
    QVector<QVector<float>> mat_b = toVector(str_b);

    QVector<QVector<float>> res;
    switch (opIndex) {
    case 0: res = Matrix::add(mat_a, mat_b); break;
    case 1: res = Matrix::subtract(mat_a, mat_b); break;
    case 2: res = Matrix::multiply(mat_a, mat_b); break;
    default: break;
    }

    QStringList resStr = toStringList(res);
    return resStr;
}

QStringList CppTests::testTranspose(QStringList str)
{
    QVector<QVector<float>> mat = toVector(str);
    QVector<QVector<float>> transposed = Matrix::transpose(mat);

    QStringList transposedStr = toStringList(transposed);
    return transposedStr;
}

QVector<qreal> CppTests::dataTest(QVector<qreal> arr)
{
    /* This works. 2d arrays dont. Only for qreal not float */
    qDebug() << arr;
    return arr;
}
