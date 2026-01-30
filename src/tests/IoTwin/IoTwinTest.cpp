#include <gtest/gtest.h>
#include <IoTwin/Iotwin.h>

TEST(IoTwin, BasicAssertion) {
    EXPECT_EQ(32, 32);

    auto& instance = IoTwin::GetInstance();
    
}
