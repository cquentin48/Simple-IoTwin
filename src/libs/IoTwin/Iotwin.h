#pragma once

/**
 * IoTwin instance
 */
class IoTwin {
 private:
    /**
     * Private constructor (default one)
     */
    IoTwin() = default;

    int i = 3;

 public:
    IoTwin(IoTwin &other) = delete;

    void operator=(const IoTwin &) = delete;

    /**
     * Returns created instance. Creates one if not already created
     * @returns Class created instance
     */
    static IoTwin& GetInstance();

    /**
     * Returns i class variable
     */
    int getI();
};

