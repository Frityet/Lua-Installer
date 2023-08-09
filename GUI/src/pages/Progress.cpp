#include "Progress.hpp"
#include "Qt.hpp"

using namespace pages;

Progress::Progress(QWidget *parent) : QWizardPage(parent)
{
     Progressbar = new QProgressBar();
      Status = new QLabel("neat");
}

void Progress::initializePage()
{
    this->setTitle("Installation status");
    this->setSubTitle("Alright now what the hell");
    auto layout = new QVBoxLayout(this);
    layout->addWidget(Progressbar);
    layout->addWidget(Status);
    Progressbar->setValue(10);
    this->setLayout(layout);
}

void Progress::SetProgress(){
    Progressbar->setValue(100);
}
