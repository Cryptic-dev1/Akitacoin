// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Raven Core developers
// Copyright (c) 2020-2024 The Akitacoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef AKITACOIN_QT_AKITACOINADDRESSVALIDATOR_H
#define AKITACOIN_QT_AKITACOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class AkitacoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit AkitacoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** akitacoin address widget validator, checks for a valid akitacoin address.
 */
class AkitacoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit AkitacoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // AKITACOIN_QT_AKITACOINADDRESSVALIDATOR_H
