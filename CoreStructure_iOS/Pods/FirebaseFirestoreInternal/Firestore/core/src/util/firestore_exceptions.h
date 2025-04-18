/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef FIRESTORE_CORE_SRC_UTIL_FIRESTORE_EXCEPTIONS_H_
#define FIRESTORE_CORE_SRC_UTIL_FIRESTORE_EXCEPTIONS_H_

// Common C++ exception declarations across iOS and Android. These aren't a
// public API surface.
//
// See exception.h for how to throw exceptions in a platform-agnostic way.

#include <exception>
#include <string>

#include "Firestore/core/include/firebase/firestore/firestore_errors.h"

#include "absl/base/config.h"

#if ABSL_HAVE_EXCEPTIONS
#define FIRESTORE_HAVE_EXCEPTIONS 1
#endif

namespace firebase {
namespace firestore {

#if FIRESTORE_HAVE_EXCEPTIONS

/**
 * An exception thrown if Firestore encounters an unhandled error.
 */
class FirestoreException : public std::exception {
 public:
  FirestoreException(const std::string& message, Error code)
      : message_(message), code_(code) {
  }

  const char* what() const noexcept override {
    return message_.c_str();
  }

  Error code() const {
    return code_;
  }

 private:
  std::string message_;
  Error code_;
};

/**
 * An exception thrown if Firestore encounters an internal, unrecoverable error.
 */
class FirestoreInternalError : public FirestoreException {
 public:
  FirestoreInternalError(const std::string& message,
                         Error code = Error::kErrorInternal)
      : FirestoreException(message, code) {
  }
};

#endif  // FIRESTORE_HAVE_EXCEPTIONS

}  // namespace firestore
}  // namespace firebase

#endif  // FIRESTORE_CORE_SRC_UTIL_FIRESTORE_EXCEPTIONS_H_
