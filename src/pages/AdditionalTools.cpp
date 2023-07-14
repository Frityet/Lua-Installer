#include "AdditionalTools.hpp"
#include "utilities.hpp"
#include <iostream>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QCheckBox>
#include <QList>
using namespace pages;

AdditionalTools::AdditionalTools(QWidget *parent) : QWizardPage(parent)
{
    Make = new QCheckBox("Make");
    Mingw = new QCheckBox("Mingw");
    LLVM = new QCheckBox("LLVM");
connect(Make, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
    } else if (state == Qt::Checked) {
    }
});
connect(Mingw, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
    } else if (state == Qt::Checked) {
    }
});
connect(LLVM, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
    } else if (state == Qt::Checked) {
    }
});
}


void AdditionalTools::initializePage()
{
    this->setTitle("Select Aditionals tools");
    this->setSubTitle("Select the additional tools you wish to install.");
    auto layout = new QVBoxLayout(this);
    QList<QCheckBox*> checkBoxList;
    checkBoxList.append(Make);
    checkBoxList.append(Mingw);
    checkBoxList.append(LLVM);
    layout->addWidget(Make);
    layout->addWidget(Mingw);
    layout->addWidget(LLVM);
    checkBoxList.at(0)->setChecked(true);
    checkBoxList.at(1)->setChecked(true);
    this->setLayout(layout);
}
