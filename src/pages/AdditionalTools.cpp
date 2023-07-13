
#include "AdditionalTools.hpp"
#include "utilities.hpp"

#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QCheckBox>
using namespace pages;

AdditionalTools::AdditionalTools(QWidget *parent) : QWizardPage(parent)
{}

void AdditionalTools::initializePage()
{
    this->setTitle("Select Luarocks version");
    this->setSubTitle("Select the version of Luarocks you want to install.");
    auto layout = new QVBoxLayout(this);
    auto _checkbox1 = new QCheckBox("Checkbox 1");
    auto _checkbox2 = new QCheckBox("Checkbox 2");
    auto _checkbox3 = new QCheckBox("Checkbox 3");
    layout->addWidget(_checkbox1);
    layout->addWidget(_checkbox2);
    layout->addWidget(_checkbox3);

    this->setLayout(layout);
}
