#pragma once

namespace vcpkg::Parse
{
    struct TextRowCol
    {
        constexpr TextRowCol() noexcept = default;
        constexpr TextRowCol(int row, int column) noexcept : row(row), column(column) {}
        /// '0' indicates uninitialized; '1' is the first row.
        int row = 0;
        /// '0' indicates uninitialized; '1' is the first column.
        int column = 0;
    };
}
