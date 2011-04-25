#include <cstdlib>
#include <cassert>
#include <algorithm>
#include <stdexcept>
#include <vector>
#include <iostream>

#include <boost/noncopyable.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/preprocessor/stringize.hpp>
#include <boost/preprocessor/tuple/elem.hpp>
#include <boost/preprocessor/seq/for_each.hpp>

#include <arpa/inet.h>
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_TRUETYPE_TABLES_H


FT_Int16 native_endian(FT_Int16 value) {
  return ntohs(value);
}

FT_UInt16 native_endian(FT_UInt16 value) {
  return ntohs(value);
}

FT_Int32 native_endian(FT_Int32 value) {
  return ntohl(value);
}

FT_UInt32 native_endian(FT_UInt32 value) {
  return ntohl(value);
}


template<typename T>
struct __attribute__((packed)) Number {
  T value;

  T operator()() const {
    return native_endian(value);
  }
};

template<typename Char, typename Traits, typename T>
std::basic_ostream<Char, Traits>& operator<<(std::basic_ostream<Char, Traits>& stream, const Number<T>& value) {
  return stream << value();
}

typedef Number<FT_Int16> NumberS16;
typedef Number<FT_UInt16> NumberU16;
typedef Number<FT_Int32> NumberS32;
typedef Number<FT_UInt32> NumberU32;
typedef NumberU16 OffsetU16;


/* template<typename T>
struct __attribute__((packed)) Percentage {
  Number<T> value;
};

template<typename Char, typename Traits, typename T>
std::basic_ostream<Char, Traits>& operator<<(std::basic_ostream<Char, Traits>& stream, const Percentage<T>& value) {
  return stream << (value.value() / 100.0);
}

typedef Percentage<FT_Int16> PercentageS16;
typedef Percentage<FT_UInt16> PercentageU16; */


template<typename T>
struct __attribute__((packed)) Length {
  Number<T> value;
};

typedef Length<FT_Int16> LengthS16;
typedef Length<FT_UInt16> LengthU16;


struct __attribute__((packed)) MathValueRecord {
  LengthS16 value;
  OffsetU16 device_table;
};

struct ScaledMathValueRecord {
  ScaledMathValueRecord(double value, FT_UInt16 device_table): value(value), device_table(device_table) { }
  double value;
  FT_UInt16 device_table;
};

template<typename Char, typename Traits>
std::basic_ostream<Char, Traits>& operator<<(std::basic_ostream<Char, Traits>& stream, const ScaledMathValueRecord& value) {
  return stream << value.value;
  /*if (value.device_table) stream << '*';
    return stream;*/
}


class Library: private boost::noncopyable {
public:
  Library() {
    FT_Error error = FT_Init_FreeType(&m_handle);
    if (error) throw std::runtime_error("Could not initialize FreeType library");
  }

  ~Library() {
    FT_Done_FreeType(m_handle);
  }

  FT_Library handle() const {
    return m_handle;
  }

private:
  FT_Library m_handle;
};


typedef std::vector<FT_Byte> TableBuffer;


class Face: private boost::noncopyable {
public:
  explicit Face(const Library& library, const char* path, FT_Long index = 0) {
    FT_Error error = FT_New_Face(library.handle(), path, index, &m_handle);
    if (error) throw std::runtime_error("Could not load font face");
  }

  ~Face() {
    FT_Done_Face(m_handle);
  }

  FT_Face handle() const {
    return m_handle;
  }

  TableBuffer load_table(FT_ULong tag, FT_Long offset = 0) const {
    FT_ULong length = 0;
    FT_Error error = FT_Load_Sfnt_Table(m_handle, tag, offset, 0, &length);
    if (error) throw std::runtime_error("Could not get table size");
    TableBuffer result(length);
    error = FT_Load_Sfnt_Table(m_handle, tag, offset, &result[0], &length);
    if (error) throw std::runtime_error("Could not load table");
    return result;
  }

  template<typename T>
  Number<T> scale(const Number<T>& value) {
    return value;
  }

  /* template<typename T>
  Percentage<T> scale(const Percentage<T>& value) {
    return value;
    } */

  template<typename T>
  double scale(const Length<T>& value) {
    return value.value() / static_cast<double>(m_handle->units_per_EM);
  }

  ScaledMathValueRecord scale(const MathValueRecord& value) {
    return ScaledMathValueRecord(this->scale(value.value), value.device_table());
  }

private:
  FT_Face m_handle;
};


struct __attribute__((packed)) MathHeader {
  NumberU32 version;
  OffsetU16 constants;
  OffsetU16 glyph_info;
  OffsetU16 variants;
};


#define MATH_CONSTANTS                                          \
  ((NumberS16, ScriptPercentScaleDown))                         \
  ((NumberS16, ScriptScriptPercentScaleDown))                   \
  ((LengthU16, DelimitedSubFormulaMinHeight))                   \
  ((LengthU16, DisplayOperatorMinHeight))                       \
  ((MathValueRecord, MathLeading))                              \
  ((MathValueRecord, AxisHeight))                               \
  ((MathValueRecord, AccentBaseHeight))                         \
  ((MathValueRecord, FlattenedAccentBaseHeight))                \
  ((MathValueRecord, SubscriptShiftDown))                       \
  ((MathValueRecord, SubscriptTopMax))                          \
  ((MathValueRecord, SubscriptBaselineDropMin))                 \
  ((MathValueRecord, SuperscriptShiftUp))                       \
  ((MathValueRecord, SuperscriptShiftUpCramped))                \
  ((MathValueRecord, SuperscriptBottomMin))                     \
  ((MathValueRecord, SuperscriptBaselineDropMax))               \
  ((MathValueRecord, SubSuperscriptGapMin))                     \
  ((MathValueRecord, SuperscriptBottomMaxWithSubscript))        \
  ((MathValueRecord, SpaceAfterScript))                         \
  ((MathValueRecord, UpperLimitGapMin))                         \
  ((MathValueRecord, UpperLimitBaselineRiseMin))                \
  ((MathValueRecord, LowerLimitGapMin))                         \
  ((MathValueRecord, LowerLimitBaselineDropMin))                \
  ((MathValueRecord, StackTopShiftUp))                          \
  ((MathValueRecord, StackTopDisplayStyleShiftUp))              \
  ((MathValueRecord, StackBottomShiftDown))                     \
  ((MathValueRecord, StackBottomDisplayStyleShiftDown))         \
  ((MathValueRecord, StackGapMin))                              \
  ((MathValueRecord, StackDisplayStyleGapMin))                  \
  ((MathValueRecord, StretchStackTopShiftUp))                   \
  ((MathValueRecord, StretchStackBottomShiftDown))              \
  ((MathValueRecord, StretchStackGapAboveMin))                  \
  ((MathValueRecord, StretchStackGapBelowMin))                  \
  ((MathValueRecord, FractionNumeratorShiftUp))                 \
  ((MathValueRecord, FractionNumeratorDisplayStyleShiftUp))     \
  ((MathValueRecord, FractionDenominatorShiftDown))             \
  ((MathValueRecord, FractionDenominatorDisplayStyleShiftDown)) \
  ((MathValueRecord, FractionNumeratorGapMin))                  \
  ((MathValueRecord, FractionNumDisplayStyleGapMin))            \
  ((MathValueRecord, FractionRuleThickness))                    \
  ((MathValueRecord, FractionDenominatorGapMin))                \
  ((MathValueRecord, FractionDenomDisplayStyleGapMin))          \
  ((MathValueRecord, SkewedFractionHorizontalGap))              \
  ((MathValueRecord, SkewedFractionVerticalGap))                \
  ((MathValueRecord, OverbarVerticalGap))                       \
  ((MathValueRecord, OverbarRuleThickness))                     \
  ((MathValueRecord, OverbarExtraAscender))                     \
  ((MathValueRecord, UnderbarVerticalGap))                      \
  ((MathValueRecord, UnderbarRuleThickness))                    \
  ((MathValueRecord, UnderbarExtraDescender))                   \
  ((MathValueRecord, RadicalVerticalGap))                       \
  ((MathValueRecord, RadicalDisplayStyleVerticalGap))           \
  ((MathValueRecord, RadicalRuleThickness))                     \
  ((MathValueRecord, RadicalExtraAscender))                     \
  ((MathValueRecord, RadicalKernBeforeDegree))                  \
  ((MathValueRecord, RadicalKernAfterDegree))                   \
  ((NumberU16, RadicalDegreeBottomRaisePercent))


struct __attribute__((packed)) MathConstants {
#define VISITOR(r, data, elem) BOOST_PP_TUPLE_ELEM(2, 0, elem) BOOST_PP_TUPLE_ELEM(2, 1, elem);
  BOOST_PP_SEQ_FOR_EACH(VISITOR, , MATH_CONSTANTS)
#undef VISITOR
};


int main(int argc, char* argv[]) {
  if (argc != 3) throw std::runtime_error("Invalid number of arguments");
  Library library;
  const char* path = argv[1];
  FT_Long index = boost::lexical_cast<FT_Long>(argv[2]);
  Face face(library, path, index);
  FT_Tag tag = FT_MAKE_TAG('M', 'A', 'T', 'H');
  TableBuffer table(face.load_table(tag));
  MathHeader* header = reinterpret_cast<MathHeader*>(&table[0]);
  FT_UInt32 version = header->version();
  if (version != 0x10000) throw std::runtime_error("Invalid math table version");
  FT_UInt16 offset = header->constants();
  MathConstants* constants = reinterpret_cast<MathConstants*>(&table[offset]);
#define VISITOR(r, data, elem) std::cout << BOOST_PP_STRINGIZE(BOOST_PP_TUPLE_ELEM(2, 1, elem)) "\t" << face.scale(constants->BOOST_PP_TUPLE_ELEM(2, 1, elem)) << std::endl;
  BOOST_PP_SEQ_FOR_EACH(VISITOR, , MATH_CONSTANTS)
#undef VISITOR
}
