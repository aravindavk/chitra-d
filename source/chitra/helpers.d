module chitra.helpers;

double inch(T)(T value)
{
    return value * 72;
}

double cm(T)(T value)
{
    return (value / 2.54).inch;
}

double mm(T)(T value)
{
    return (value / 10).cm;
}
