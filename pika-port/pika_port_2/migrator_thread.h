#ifndef MIGRATOR_THREAD_H_
#define MIGRATOR_THREAD_H_

#include <iostream>
#include <atomic>
#include "nemo.h"
#include "pink/include/redis_cli.h"
#include "pika_sender.h"

class MigratorThread : public pink::Thread {
 public:
  MigratorThread(nemo::Nemo *db, std::vector<PikaSender *> *senders, char type, int thread_num) :
      db_(db),
      senders_(senders),
      type_(type),
      thread_num_(thread_num),
      thread_index_(0),
      num_(0),
      should_exit_(false),
      is_finish_(false)
      {
        set_thread_name("migrator");
      }


  int64_t num() {
    slash::MutexLock l(&num_mutex_);
    return num_;
  }

  virtual ~MigratorThread() { }
  bool is_finish() {return is_finish_; }

  void Stop() { should_exit_ = true; }

 private:
  nemo::Nemo *db_;
  std::vector<PikaSender *> *senders_;
  char type_;
  int thread_num_;
  int thread_index_;

  void MigrateDB(const char type);
  void DispatchKey(const std::string &key);

  int64_t num_;
  std::atomic<bool> should_exit_;
  slash::Mutex num_mutex_;
  bool is_finish_;

  void PlusNum() {
    slash::MutexLock l(&num_mutex_);
    ++num_;
  }
  virtual void *ThreadMain();
};
#endif
