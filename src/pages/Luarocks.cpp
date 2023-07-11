#include "Luarocks.hpp"
#include "utilities.hpp"

#include <QtWidgets/QVBoxLayout>

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

    // _versions = _package.version.find_all_versions(&_http, Version {
    //     .major = 3,
    //     .minor = 0,
    //     .patch = 0,
    // }, Version {
    //     .major = 4,
    //     .minor = 10,
    //     .patch = 10,
    // });
    _versions = std::async([](){
        return std::map<std::string, HTTPResponse> {
            {
                "3.9.2",
                {
                    .data = "",
                    .code = 200,
                }
            },
        };
    });
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
    if (_versions.wait_for(std::chrono::seconds(0)) == std::future_status::ready) {
        auto versions = _versions.get();

        for (auto const &[version, response] : versions) {
            if (response.code == 200) {
                _picker->addItem(QString::fromStdString(version));
            }
        }

        _loading->hide();
        _picker->setEnabled(true);
        _timer->stop();
    }
}
