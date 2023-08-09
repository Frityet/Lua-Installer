#include "Lua.hpp"
#include "Version.hpp"

using namespace pages;

Lua::Lua(QWidget *parent) : QWizardPage(parent)
{
    _picker = new QComboBox(this);
    _picker->setEditable(false);
    _picker->setEnabled(false);
    //On picker change, set the `package.version` to the selected version
    connect(_picker, QOverload<int>::of(&QComboBox::currentIndexChanged), [this](int index){
        Version v;
        sscanf(_picker->itemText(index).toStdString().c_str(), package.url_format.c_str(), &v.major, &v.minor, &v.patch);
        package.version = v;
    });

    _timer = new QTimer(this);
    connect(_timer, &QTimer::timeout, this, &Lua::check_future);
    _timer->start(500);

    _loading = new QLabel("Loading versions...");
    _loading->setAlignment(Qt::AlignCenter);
}

void Lua::initializePage()
{
    this->setTitle("Select Lua version");
    this->setSubTitle("Select the version of Lua you want to install.");
    auto layout = new QVBoxLayout(this);

    layout->addWidget(_loading);
    layout->addWidget(_picker);

    this->setLayout(layout);
}

void Lua::check_future()
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
