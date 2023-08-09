#include "AdditionalTools.hpp"
#include "utilities.hpp"
#include <iostream>

using namespace pages;

AdditionalTools::AdditionalTools(bool *make, bool *mingw, bool *llvm, QWidget *parent) : QWizardPage(parent)
{
    _make_checkbox = new QCheckBox("Make");
    _mingw_checkbox = new QCheckBox("Mingw");
    _llvm_checkbox = new QCheckBox("LLVM");
    connect(_make_checkbox, &QCheckBox::stateChanged, [make](int state) {
        if (state == Qt::Unchecked) {
        } else if (state == Qt::Checked) {
            *make = true;
        }
    });
    connect(_mingw_checkbox, &QCheckBox::stateChanged, [mingw](int state) {
        if (state == Qt::Unchecked) {
        } else if (state == Qt::Checked) {
            *mingw = true;
        }
    });
    connect(_llvm_checkbox, &QCheckBox::stateChanged, [llvm](int state) {
        if (state == Qt::Unchecked) {
        } else if (state == Qt::Checked) {
            *llvm = true;
        }
    });
}


void AdditionalTools::initializePage()
{
    this->setTitle("Select Aditionals tools");
    this->setSubTitle("Select the additional tools you wish to install.");
    auto layout = new QVBoxLayout(this);
    QList<QCheckBox*> checkBoxList;
    checkBoxList.append(_make_checkbox);
    checkBoxList.append(_mingw_checkbox);
    checkBoxList.append(_llvm_checkbox);
    layout->addWidget(_make_checkbox);
    layout->addWidget(_mingw_checkbox);
    layout->addWidget(_llvm_checkbox);
    checkBoxList.at(0)->setChecked(true);
    checkBoxList.at(1)->setChecked(true);
    this->setLayout(layout);
}
