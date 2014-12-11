#include <iostream>
#include <cstdlib>
#include <unistd.h>


using namespace std;

int main()
{
    unsigned int microseconds = 2000000;
    system ("rfkill unblock 0");
    usleep(microseconds);
    system ("service hostapd stop");
    system ("killall hostapd");
    usleep(microseconds);

    return 0;
}
