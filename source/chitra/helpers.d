module chitra.helpers;

// 1pt = 1/72 of inch
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

// 1 pt = 1/72 of inch and 1 px = 1/96 of inch
double px(T)(T value)
{
    return (72.0/96.0) * value;
}

// No conversion needed
double pt(T)(T value)
{
    return value;
}
