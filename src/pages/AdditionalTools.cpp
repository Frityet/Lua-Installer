#include "AdditionalTools.hpp"
#include "utilities.hpp"
#include "choices.hpp"
#include <iostream>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QCheckBox>
#include <QList>
install choices;
using namespace pages;

void onInteraction(){
    std::cout<<"nice! \n";
}
AdditionalTools::AdditionalTools(QWidget *parent) : QWizardPage(parent)
{
    Make = new QCheckBox("Make");
    Mingw = new QCheckBox("Mingw");
    LLVM = new QCheckBox("LLVM");
connect(Make, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
        choices.make = false;
    } else if (state == Qt::Checked) {
                choices.make = true;
    }
});
connect(Mingw, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
        choices.mingw = false;
    } else if (state == Qt::Checked) {
        choices.mingw = true;
    }
});
connect(LLVM, &QCheckBox::stateChanged, [this](int state) {
    if (state == Qt::Unchecked) {
        choices.llvm = false;
    } else if (state == Qt::Checked) {
        choices.llvm = true;
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
