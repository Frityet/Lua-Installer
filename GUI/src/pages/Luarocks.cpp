#include "Luarocks.hpp"
#include "utilities.hpp"

using namespace pages;

Luarocks::Luarocks(QWidget *parent) : QWizardPage(parent)
{
    _http = curlpp::Multi();

    _picker = new QComboBox(this);
    _picker->setEditable(false);
    _picker->setEnabled(false);
    connect(_picker, QOverload<int>::of(&QComboBox::currentIndexChanged), [this](int index){
        Version v;
        sscanf(_picker->itemText(index).toStdString().c_str(), package.url_format.c_str(), &v.major, &v.minor, &v.patch);
        package.version = v;
    });

    _timer = new QTimer(this);
    connect(_timer, &QTimer::timeout, this, &Luarocks::check_future);
    _timer->start(500);

    _loading = new QLabel("Loading versions...");
    _loading->setAlignment(Qt::AlignCenter);
}

void Luarocks::initializePage()
{
    this->setTitle("Select Luarocks version");
    this->setSubTitle("Select the version of Luarocks you want to install.");
    auto layout = new QVBoxLayout(this);

    layout->addWidget(_loading);
    layout->addWidget(_picker);

    this->setLayout(layout);
}

void Luarocks::check_future()
{
    if (package.finished_fetching_versions()) {
        auto versions = package.versions();

        for (Version version : versions)
            _picker->addItem(QString::fromStdString(version.to_string()));


        _loading->hide();
        _picker->setEnabled(true);
        _timer->stop();
    }
}
