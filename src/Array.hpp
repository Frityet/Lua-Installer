
// template<typename T>
// class Array {
// private:
//     std::sha
// };

#include <memory>

template<typename T>
struct ImmutableArrayData;

template<typename T>
using Array = std::unique_ptr<ImmutableArrayData<T>>;

template<typename T>
using SharedArray = std::shared_ptr<ImmutableArrayData<T>>;

template<typename T>
struct ImmutableArrayData {
    const size_t length;
    T data[];

private:
    ImmutableArrayData(size_t length) : length(length) {}

public:
    static Array<T> create(size_t length)
    { return std::unique_ptr<ImmutableArrayData<T>>(new(new std::byte[sizeof(ImmutableArrayData<T>) + sizeof(T) * length]) ImmutableArrayData<T>(length)); }

    static SharedArray<T> create_shared(size_t length)
    { return std::shared_ptr<ImmutableArrayData<T>>(new(new std::byte[sizeof(ImmutableArrayData<T>) + sizeof(T) * length]) ImmutableArrayData<T>(length)); }

    static Array<T> create(const std::initializer_list<T> &list)
    {
        auto array = create(list.size());
        size_t i = 0;
        for (const T &item : list)
            array->data[i++] = item;
        return array;
    }

    static SharedArray<T> create_shared(const std::initializer_list<T> &list)
    {
        auto array = create_shared(list.size());
        size_t i = 0;
        for (const T &item : list)
            array->data[i++] = item;
        return array;
    }

    T *begin()
    { return data; }

    T *end()
    { return data + length; }

    const T *begin() const
    { return data; }

    const T *end() const
    { return data + length; }

    const T *cbegin() const
    { return data; }

    const T *cend() const
    { return data + length; }

    T &operator[](size_t index)
    {
        if (index >= length) throw std::out_of_range("Index out of range");
        return data[index];
    }

    const T &operator[](size_t index) const
    {
        if (index >= length) throw std::out_of_range("Index out of range");
        return data[index];
    }

    ImmutableArrayData<T> &operator=(const ImmutableArrayData<T> &other)
    {
        if (this == &other) return *this;
        if (length != other.length) throw std::invalid_argument("Lengths of arrays are not equal");
        for (size_t i = 0; i < length; i++)
            data[i] = other.data[i];

        return *this;
    }

    ImmutableArrayData<T> &operator=(ImmutableArrayData<T> &&other) noexcept
    {
        if (this == &other) return *this;
        if (length != other.length) throw std::invalid_argument("Lengths of arrays are not equal");
        for (size_t i = 0; i < length; i++)
            data[i] = std::move(other.data[i]);

        return *this;
    }

    ImmutableArrayData<T> &operator=(const std::initializer_list<T> &list)
    {
        if (length != list.size()) throw std::invalid_argument("Lengths of arrays are not equal");
        size_t i = 0;
        for (T &item : list)
            data[i++] = item;

        return *this;
    }

    bool operator==(const ImmutableArrayData<T> &other) const
    {
        if (this == &other) return true;
        if (length != other.length) return false;
        for (size_t i = 0; i < length; i++)
            if (data[i] != other.data[i]) return false;
        return true;
    }

    bool operator!=(const ImmutableArrayData<T> &other) const
    { return !(*this == other); }
};
