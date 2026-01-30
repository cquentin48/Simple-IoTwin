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

 public:
    IoTwin(IoTwin &other) = delete;

    void operator=(const IoTwin &) = delete;

    /**
     * Returns created instance. Creates one if not already created
     * @returns Class created instance
     */
    static IoTwin& GetInstance();
};

