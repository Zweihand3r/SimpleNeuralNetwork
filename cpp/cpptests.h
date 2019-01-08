#ifndef CPPTESTS_H
#define CPPTESTS_H

#include <QObject>
#include <QVector>
#include <QList>
#include <QDebug>

#include "cpp/matrix.h"

class CppTests : public QObject
{
    Q_OBJECT
public:
    explicit CppTests(QObject *parent = nullptr);

private:
    QVector<QVector<float>> toVector(const QStringList stringList);
    QStringList toStringList(const QVector<QVector<float>> vector);

signals:

public slots:
    QStringList testDot(QStringList str_a, QStringList str_b);
    QStringList testBasicOperation(QStringList str_a, QStringList str_b, int opIndex);
    QStringList testTranspose(QStringList str);

    QVector<qreal> dataTest(QVector<qreal> arr);
};

#endif // CPPTESTS_H
